# =======================
# 📦 Makefile for Uniswap v1 Project
# =======================

# Load environment variables from .env
include .env

# ========== Config ==========
RPC_URL ?= $(ETH_RPC_URL)
PRIVATE_KEY ?= $(PRIVATE_KEY)
DEPLOY_SCRIPT_DIR = script

# ========== Utilities ==========
.PHONY: install-foundry install-node-deps build-contracts \
        deploy-token deploy-exchange deploy-factory deploy-all \
        build-frontend start-frontend clean fmt dev

# ========== 1. Tool Installation ==========
install-foundry:
	curl -L https://foundry.paradigm.xyz | bash && \
	source $$HOME/.bashrc && \
	foundryup

install-node-deps:
	cd frontend && npm install

# ========== 2. Smart Contract Tasks ==========
build-contracts:
	cd contracts && forge build

fmt:
	cd contracts && forge fmt

deploy-token:
	forge script $(DEPLOY_SCRIPT_DIR)/DeployToken.s.sol:DeployToken \
		--rpc-url $(RPC_URL) \
		--private-key $(PRIVATE_KEY) \
		--broadcast

deploy-exchange:
	forge script $(DEPLOY_SCRIPT_DIR)/DeployExchange.s.sol:DeployExchange \
		--rpc-url $(RPC_URL) \
		--private-key $(PRIVATE_KEY) \
		--broadcast

deploy-factory:
	forge script $(DEPLOY_SCRIPT_DIR)/DeployFactory.s.sol:DeployFactory \
		--rpc-url $(RPC_URL) \
		--private-key $(PRIVATE_KEY) \
		--broadcast

deploy-all: deploy-token deploy-exchange deploy-factory

# ========== 3. Frontend Tasks ==========
build-frontend:
	cd frontend && npm run build

start-frontend:
	cd frontend && npm run dev

dev: install-node-deps start-frontend

# ========== 4. One Click All ==========
all: install-foundry install-node-deps build-contracts deploy-all build-frontend

# ========== 5. Cleanup ==========
clean:
	cd contracts && forge clean
	cd frontend && rm -rf node_modules dist
