import { GoogleGenerativeAI } from "@google/generative-ai";

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

async function runAgent() {
  console.log("--- 1. Agent Initializing ---");

  try {
    // UPDATED: Using the current 2026 stable alias
    const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

    console.log("--- 2. Connecting to Gemini 2.5 Flash... ---");

    const result = await model.generateContent("System check: Confirm you are online.");
    const response = await result.response;
    
    console.log("--- 3. Agent Response ---");
    console.log(response.text());

  } catch (error) {
    console.error("--- ERROR ---");
    console.error(error.message);
    console.log("HINT: If you still see 404, try 'gemini-3.1-flash-preview'");
  }
}

runAgent();