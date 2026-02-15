import {setGlobalOptions} from "firebase-functions";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import axios from "axios";

setGlobalOptions({maxInstances: 10});

interface AuroraStation {
  "Aika": string;
  "R-luku": number | null;
  "Ylempi raja-arvo": number;
  "Alempi raja-arvo": number;
  "Asema": string;
  "Leveyspiiri": number;
  "Pituuspiiri": number;
}

interface ApiResponse {
  data: Record<string, AuroraStation>;
}

admin.initializeApp();

export const fetchAuroraData = onSchedule(
  {
    schedule: "every 5 minutes",
    region: "europe-west1",
    memory: "256MiB",
  },
  async () => {
    try {
      // Haetaan tiedot revontulten aktiivisuudesta API:sta
      const response = await axios.get<ApiResponse>(
        "https://space.fmi.fi/MIRACLE/RWC/data/r_index_latest_fi.json",
        {timeout: 5000}
      );

      const stations = response.data.data;
      const updates: Record<string, unknown> = {};
      const now = Date.now();
      const COOLDOWN_MS = 30 * 60 * 1000; // 30 min

      // Käydään asemat läpi
      for (const stationCode in stations) {
        if (!Object.prototype.hasOwnProperty.call(stations, stationCode)) {
          continue;
        }

        const station = stations[stationCode];

        // Aseman revontulitiedot asettaminen
        updates[`aurora/${stationCode}`] = {
          time: station["Aika"],
          rValue: station["R-luku"],
          upperLimit: station["Ylempi raja-arvo"],
          lowerLimit: station["Alempi raja-arvo"],
          name: station["Asema"],
          lat: station["Leveyspiiri"],
          lon: station["Pituuspiiri"],
          updatedAt: now,
        };

        // Ylä- ja ala-raja arvojen puolivälin laskeminen
        // Käytetään ilmoituksen rajana
        const moderateChance =
          station["Alempi raja-arvo"] +
          (station["Ylempi raja-arvo"] - station["Alempi raja-arvo"]) / 2;

        // Tarkistetaan ylittääkö aseman R-luku moderateChance raja-arvon
        if (station["R-luku"] !== null && station["R-luku"] >= moderateChance) {
          const cooldownRef =
            admin.database().ref(`auroraCooldown/${stationCode}`);
          const cooldownSnap = await cooldownRef.get();
          const lastAlertAt = cooldownSnap.exists() ?
            cooldownSnap.val().lastAlertAt : null;

          // Tarkistetaan, onko viime ilmoituksesta kulunut tarpeeksi aikaa
          if (lastAlertAt && now - lastAlertAt < COOLDOWN_MS) {
            logger.info("Cooldown active for ", stationCode);
            continue;
          }

          const titleText = "Aurora Alert";
          const bodyText =
            station["R-luku"] >= station["Ylempi raja-arvo"] ?
              "High chance for aurora" :
              "Moderate chance for aurora";

          // Lähetetään ilmoitus kaikille aseman topicciin subscribaneille
          try {
            const messageId = await admin.messaging().send({
              topic: stationCode,
              notification: {
                title: titleText,
                body: bodyText,
              },
            });

            logger.info("Aurora alert: ", messageId);

            // Tallennetaan ilmoituksen ajankohta tietokantaan
            await cooldownRef.set({lastAlertAt: now});
          } catch (e) {
            logger.error("Push failed", e);
          }
        }
      }

      // Päivitetään kaikkien asemien revontulitiedot
      await admin.database().ref().update(updates);

      logger.info("Aurora data päivitetty");
    } catch (error) {
      logger.error("Virhe API-haussa", error);
    }
  }
);
