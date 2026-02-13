import { setGlobalOptions } from "firebase-functions";
import { onSchedule } from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import axios from "axios";

setGlobalOptions({ maxInstances: 10 });

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
    region: "europe-north1",
    memory: "256MiB",
  },
  async () => {
    try {
      const response = await axios.get<ApiResponse>(
        "https://space.fmi.fi/MIRACLE/RWC/data/r_index_latest_fi.json",
        { timeout: 5000 }
      );

      const stations = response.data.data;

      const updates: Record<string, unknown> = {};

      for (const stationCode in stations) {
        const station = stations[stationCode];

        updates[`aurora/${stationCode}`] = {
          time: station["Aika"],
          rValue: station["R-luku"],
          upperLimit: station["Ylempi raja-arvo"],
          lowerLimit: station["Alempi raja-arvo"],
          name: station["Asema"],
          lat: station["Leveyspiiri"],
          lon: station["Pituuspiiri"],
          updatedAt: Date.now(),
        };

        let moderateChance: number = station["Alempi raja-arvo"] + (station["Ylempi raja-arvo"] - station["Alempi raja-arvo"]) / 2;
        if (station["R-luku"] !== null && station["R-luku"] >= moderateChance) {
          let titleText: string = "Aurora Alert";
          let bodyText: string = "Moderate chance for aurora";

          if (station["R-luku"] >= station["Ylempi raja-arvo"]) {
            bodyText = "High chance for aurora";
          }

          await admin.messaging().send({
            topic: stationCode,
            notification: {
              title: titleText,
              body: bodyText,
            }
          });
        }
      }

      await admin.database().ref().update(updates);

      logger.info("Aurora data päivitetty");
    } catch (error) {
      logger.error("Virhe API-haussa", error);
    }
  }
);
