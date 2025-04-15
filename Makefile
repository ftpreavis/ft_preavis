# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cpoulain <cpoulain@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/14 15:23:12 by cpoulain          #+#    #+#              #
#    Updated: 2025/04/15 11:17:15 by cpoulain         ###   ########.fr        #
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

all: pull-all restart	## Pull-all and restart

clone-all:	## Clone all repositories (infra and microservices)
	@printf $(MSG_SETTING_UP) infra
	@if [ ! -d "$(INFRA_DIR)" ]; then \
		printf $(MSG_CLONING) infra; \
		git clone $(INFRA_REPOS) $(INFRA_DIR) > /dev/null 2>&1; \
		printf $(MSG_DONE_CLONING) infra; \
	else \
		printf $(MSG_ALREADY_CLONED) Infra; \
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
		printf $(MSG_UPDATING) infra; \
		git -C infra pull > /dev/null 2>&1; \
		printf $(MSG_DONE_UPDATING) infra; \
	else \
		printf $(MSG_IGNORING) infra; \
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

$(MS_FOLDERS):	## Clones all microservices
	@$(MAKE) --no-print-directory clone-all

reset: down	## Removes infra and services
	@printf ${MSG_RM_DIR} $(MS_DIR)
	@${RM} -r $(MS_DIR)
	@printf ${MSG_RM_DIR} $(INFRA_DIR)
	@$(RM) -r $(INFRA_DIR)

up:		## Up the containers
	@printf $(MSG_DOCKER_UP)
	@cd $(INFRA_DIR) && $(DC) up -d --build
	@printf $(MSG_DOCKER_UP_DONE)

down:	## Shutdowns the containers
	@printf $(MSG_DOCKER_DOWN)
	@cd $(INFRA_DIR) && $(DC) down
	@printf $(MSG_DOCKER_DOWN_DONE)

restart:	## Restarts the containers
	@printf $(MSG_DOCKER_DOWN)
	@cd $(INFRA_DIR) && $(DC) down -v
	@printf $(MSG_DOCKER_DOWN_DONE)
	@$(MAKE) --no-print-directory up -d

git-status:	## Does a git status on everyrepos
	@printf $(MSG_STATUS_DIR) $(INFRA_DIR)
	@git -C $(INFRA_DIR) status -s
	@for repo in $(MS_FOLDERS); do \
		if [ -d "$$repo" ]; then \
			printf $(MSG_STATUS_DIR) $$repo; \
			git -C $$repo status -s; \
		fi; \
	done
	@printf "\n"

logs:	## Displays logs output from services
	@cd $(INFRA_DIR) && $(DC) logs -f

vault-seed:	## Seeds the vault container
	@printf $(MSG_VAULT_SEEDING)
	@cd $(SCRIPTS_DIR) && ./init_vault.sh
	@printf $(MSG_DONE_VAULT_SEEDING)

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

.PHONY:	all up down restart logs vault-seed git-status reset clone-all pull-all help new-micro
