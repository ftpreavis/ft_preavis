# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cpoulain <cpoulain@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/14 15:23:12 by cpoulain          #+#    #+#              #
#    Updated: 2025/06/04 12:28:14 by cpoulain         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# ---------------------------------------------------------------------------- #
#                                   Variables                                  #
# ---------------------------------------------------------------------------- #

# --------------------------------- Includes --------------------------------- #

include Vars.mk
include Colors.mk
include Messages.mk

# ---------------------------------------------------------------------------- #
#                                  PHONY RULES                                 #
# ---------------------------------------------------------------------------- #

all: clone-all gc-dev i deploy-db-migration up

clone-all: ## Clones all repositories
	@printf $(MSG_SETTING_UP) Infra
	@if [ ! -d "$(INFRA_DIR)" ]; then \
		printf $(MSG_CLONING) Infra; \
		git clone $(INFRA_REPOS) $(INFRA_DIR) > /dev/null 2>&1; \
		printf $(MSG_DONE_CLONING) Infra; \
	else \
		printf $(MSG_ALREADY_CLONED) Infra; \
	fi
	@printf $(MSG_SETTING_UP) Frontend
	@if [ ! -d "$(FRONT_DIR)" ]; then \
		printf $(MSG_CLONING) Frontend; \
		git clone $(FRONT_REPOS) $(FRONT_DIR) > /dev/null 2>&1; \
		printf $(MSG_DONE_CLONING) Frontend; \
	else \
		printf $(MSG_ALREADY_CLONED) Frontend; \
	fi
	@printf $(MSG_SETTING_UP) Microservices
	@mkdir -p $(MS_DIR)
	@for repo in $(MS_REPOS_NAME); do \
		if [ ! -d "$(MS_DIR)/$$repo" ]; then \
			printf $(MSG_CLONING) $$repo; \
			git clone $(ORG_URL)/$$repo.git $(MS_DIR)/$$repo > /dev/null 2>&1; \
			printf $(MSG_DONE_CLONING) $$repo; \
		else \
			printf $(MSG_ALREADY_CLONED) $$repo; \
		fi; \
	done

pull-all: $(MS_FOLDERS)	## Pulls all repositories
	@if [ -d "$(INFRA_DIR)" ]; then \
		printf $(MSG_UPDATING) Infra; \
		git -C infra pull > /dev/null 2>&1; \
		printf $(MSG_DONE_UPDATING) Infra; \
	else \
		printf $(MSG_IGNORING) Infra; \
	fi
	@printf "\n"
	@if [ -d "$(FRONT_DIR)" ]; then \
		printf $(MSG_UPDATING) Frontend; \
		git -C frontend pull > /dev/null 2>&1; \
		printf $(MSG_DONE_UPDATING) Frontend; \
	else \
		printf $(MSG_IGNORING) Frontend; \
	fi
	@printf "\n"
	@for repo in $(MS_FOLDERS); do \
		if [ -d "$$repo" ]; then \
			printf $(MSG_UPDATING) $$repo; \
			git -C $$repo pull > /dev/null 2>&1; \
			printf $(MSG_DONE_UPDATING) $$repo; \
		else \
			printf $(MSG_IGNORING) $$repo; \
		fi; \
	done

# TODO: Add if statement to npx prisma db push if db is empty. Also run export DATABASE_URL before it
install:	## Install all node projects (Alias: i)
	@printf $(MSG_INSTALLING) $(FRONT_DIR)
	@cd $(FRONT_DIR); npm install;
	@printf $(MSG_DONE_INSTALLING) $(FRONT_DIR)
	@for repo in $(MS_FOLDERS); do \
		if [ -d "$$repo" ]; then \
			printf $(MSG_INSTALLING) $$repo; \
			cd $$repo; \
			$(INSTALL); \
			cd -; \
			printf $(MSG_DONE_INSTALLING) $$repo; \
		fi; \
	done
	@printf "\n"

sudo_install:	## Install all node projects with sudo (Alias: si)
	$(MAKE) --no-print-directory install INSTALL="$(S_INSTALL)"

i:	install	## Install all node projects

si:	sudo_install	## Install all node projects with sudo

$(MS_FOLDERS):	## Clones all microservices
	@$(MAKE) --no-print-directory clone-all

reset: down	## Removes infra and services
	@printf	$(MSG_DC_MODE) "$(DC)"
	@printf ${MSG_RM_DIR} $(MS_DIR)
	@${RM} -r $(MS_DIR)
	@printf ${MSG_RM_DIR} $(INFRA_DIR)
	@$(RM) -r $(INFRA_DIR)

up:	check-mandatory-files ## Up the containers
	printf $(MSG_DC_MODE) "$(DC)"; \
	printf $(MSG_DOCKER_UP); \
	cd $(INFRA_DIR) && $(DC) up -d --build; \
	printf $(MSG_DOCKER_UP_DONE)

check-mandatory-files:
	@if [ ! -f "$(DEV_ENV_PATH)" ] || [ ! -f "$(CSV_ENV_PATH)" ]; then \
		printf $(MSG_MISSING_CONFIG_FILES); \
		[ ! -f "$(DEV_ENV_PATH)" ] && printf $(MSG_MISSING_FILE_ITEM) "$(DEV_ENV_PATH)"; \
		[ ! -f "$(CSV_ENV_PATH)" ] && printf $(MSG_MISSING_FILE_ITEM) "$(CSV_ENV_PATH)"; \
		printf $(MSG_INTERACTIVE_PROMPT); \
		read yn < /dev/tty; \
		if [ "$$yn" = "y" ] || [ "$$yn" = "Y" ]; then \
			[ ! -f "$(DEV_ENV_PATH)" ] && bash $(INIT_ENV_SCRIPT_PATH); \
			[ ! -f "$(CSV_ENV_PATH)" ] && bash $(INIT_CSV_SCRIPT_PATH); \
		else \
			printf $(MSG_ABORTING); \
			exit 1; \
		fi; \
	fi

down:	## Shutdowns the containers
	@printf	$(MSG_DC_MODE) "$(DC)"
	@printf $(MSG_DOCKER_DOWN)
	@cd $(INFRA_DIR) && $(DC) down
	@printf $(MSG_DOCKER_DOWN_DONE)

restart:	## Restarts the containers
	@printf	$(MSG_DC_MODE) "$(DC)"
	@printf $(MSG_DOCKER_DOWN)
	@cd $(INFRA_DIR) && $(DC) down -v
	@printf $(MSG_DOCKER_DOWN_DONE)
	@$(MAKE) --no-print-directory up

init-volumes: ## Inits the volumes for the prod
	mkdir -p -m770 $(VOLUMES_FOLDERS)
	sudo chown -R 100:101 /srv/ft_preavis/data/services/db-service

up-prod:		init-volumes ## Run containers in production mode
	$(MAKE) --no-print-directory up DC="$(DC_PROD)"

down-prod:		init-volumes ## Shutdowns the containers in production mode
	$(MAKE) --no-print-directory down DC="$(DC_PROD)"

restart-prod:	init-volumes ## Restarts the containers in production mode
	$(MAKE) --no-print-directory restart DC="$(DC_PROD)"

logs-prod:		init-volumes ## Show logs in production mode
	$(MAKE) --no-print-directory logs DC="$(DC_PROD)"

git-status:	## Does a git status on everyrepos
	@printf $(MSG_STATUS_DIR) $(INFRA_DIR)
	@git -C $(INFRA_DIR) status -s
	@printf $(MSG_STATUS_DIR) $(FRONT_DIR)
	@git -C $(FRONT_DIR) status -s
	@for repo in $(MS_FOLDERS); do \
		if [ -d "$$repo" ]; then \
			printf $(MSG_STATUS_DIR) $$repo; \
			git -C $$repo status -s; \
		fi; \
	done
	@printf "\n"

git-checkout:	## Checkout all repos on master (Alias: gc)
	@printf $(MSG_CHECKOUT_DIR) $(INFRA_DIR) $(BRANCH)
	@git -C $(INFRA_DIR) checkout $(BRANCH) -q
	@printf $(MSG_CHECKOUT_DIR) $(FRONT_DIR) $(BRANCH)
	@git -C $(FRONT_DIR) checkout $(BRANCH) -q
	@for repo in $(MS_FOLDERS); do \
		if [ -d "$$repo" ]; then \
			printf $(MSG_CHECKOUT_DIR) $$repo $(BRANCH); \
			git -C $$repo checkout $(BRANCH) -q; \
		fi; \
	done
	@printf "\n"

git-checkout-dev:	## Checkout all repos on dev (Alias: gc-dev)
	$(MAKE) --no-print-directory git-checkout BRANCH="$(DEV_BRANCH)"

gc-dev: git-checkout-dev	## Checkout all repos on dev

gc: git-checkout	## Checkout all repos on master

logs:	## Displays logs output from services
	@cd $(INFRA_DIR) && $(DC) logs -f

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "🛠  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

new-micro: ## Prompt to create and init new microservices
	@read -p "🧠 Enter service names (space-separated): " NAMES; \
	for NAME in $$NAMES; do \
		TARGET_DIR="services/$$NAME-service"; \
		if [ -d "$$TARGET_DIR/node_modules" ]; then \
			echo "⚠️  $$TARGET_DIR already exists. Skipping."; \
		else \
			echo "📁 Creating $$TARGET_DIR..."; \
			mkdir -p "$$TARGET_DIR"; \
			echo "🚀 Initializing $$NAME-service with Fastify..."; \
			docker run --rm -v "$$(pwd)/$$TARGET_DIR":/app init-micro; \
			echo "✅ $$NAME-service initialized."; \
		fi; \
	done

vault-seed-dev: ## If you want to re-seed the vault module
	@cd $(INFRA_DIR)/vault/seeder && docker build -f seeder.dev.dockerfile -t vault-seeder-dev .
	docker run --rm \
		--network container:vault-module \
		-e VAULT_ADDR=http://vault-module:8200 \
		-e VAULT_TOKEN=root \
		vault-seeder-dev

re-gen-db: ## Regenerate db-service database
	@if [ "$(docker ps -a -q -f name=infra-db-service) | wc -l" ]; then \
		docker exec -it -d db-service npx prisma migrate reset -f; \
		docker exec -it -d db-service npx prisma migrate dev; \
		docker exec -it -d db-service npx prisma generate; \
		docker stop db-service; \
		$(MAKE) --no-print-directory up; \
	else \
		echo "Failed ! DB-Service container not running."; \
	fi

deploy-db-migration: ## executes npx prisma migrate deploy
	cd services/db-service; npx prisma migrate deploy;

.PHONY:	all up down restart logs git-status reset clone-all pull-all help new-micro vault-seed-dev init-volumes gc gc-dev git-checkout git-checkout-dev install sudo_install i si re-gen-db check-mandatory-files deploy-db-migration
