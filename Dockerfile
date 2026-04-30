# Use the same Node version you have on your computer
FROM node:24-slim

# Create an isolated folder inside the container
WORKDIR /app

# Install the Gemini tool ONLY inside the container
COPY package.json ./
RUN npm install @google/generative-ai

# Copy your code into the container
COPY index.js ./

# Run the script
CMD ["node", "index.js"]