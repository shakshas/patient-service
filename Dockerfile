# ── Stage 1: Build ──────────────────────────────────────────
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json .
RUN npm install --production --no-cache

COPY patient-service.js .

# ── Stage 2: Production ──────────────────────────────────────
FROM node:18-alpine AS production

WORKDIR /app

# Copy only what we need from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/patient-service.js .
COPY --from=builder /app/package.json .

# Run as non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3001

CMD ["node", "patient-service.js"]
