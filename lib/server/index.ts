import {
  Application,
  Router,
} from "https://deno.land/x/denotrain@v0.5.0/mod.ts";
import { quotes } from "./quotes.ts";
// console.log("http://localhost:3000/");

const app = new Application({ hostname: "192.168.153.1" });
const router = new Router();

app.use("/api", router);

app.get("/", (ctx) => {
  return "Hello ";
});

router.get("/quotes", (ctx) => {
  return { "quotes": quotes };
});

await app.run();
