# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Vars.mk                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cpoulain <cpoulain@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/14 15:23:07 by cpoulain          #+#    #+#              #
#    Updated: 2025/06/04 12:41:24 by cpoulain         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Commands

RM						:=	/usr/bin/rm -f
ECHO					:=	/usr/bin/echo
DC						?=	docker compose -f docker-compose.dev.yml
DC_PROD					=	docker compose -f docker-compose.yml
INSTALL					?=	npm install
S_INSTALL				:=	sudo npm install

# Repos

ORG_URL					:=	git@github.com:ftpreavis
BRANCH					?=	master
DEV_BRANCH				:=	dev

# Infrastructure

INFRA_DIR				:=	infra
INFRA_REPOS				:=	$(ORG_URL)/infra.git
SCRIPT_DIR				:=	$(INFRA_DIR)/scripts
INIT_ENV_SCRIPT_PATH	:=	$(SCRIPT_DIR)/init_dev_env.sh
INIT_CSV_SCRIPT_PATH	:=	$(SCRIPT_DIR)/init_env_csv.sh
DEV_ENV_PATH			:=	$(INFRA_DIR)/env/.dev.env
CSV_ENV_PATH			:=	$(INFRA_DIR)/vault/seeder/.env.csv

# Prod volumes

VOLUMES_ROOT			:=	/srv/ft_preavis/data
VOLUMES_SUBFOLDERS		:=	vault/data vault/certs grafana/data prometheus/data nginx/logs services/db-service services/media-service env
VOLUMES_FOLDERS			:=	$(addprefix $(VOLUMES_ROOT)/, $(VOLUMES_SUBFOLDERS))
DB_PRISMA_PATH			:=	$(addprefix $(VOLUMES_ROOT)/, services/db-service/database.db)

# Frontend

FRONT_DIR				:=	frontend
FRONT_REPOS				:=	$(ORG_URL)/frontend.git

# Microservices

MS_DIR					:=	services
MS_REPOS_NAME			:=	gateway-service \
							auth-service \
							user-service \
							tournament-service \
							notification-service \
							matchmaking-service \
							chat-service \
							lobby-service \
							media-service \
							db-service

MS_FOLDERS				:=	$(addprefix $(MS_DIR)/, $(MS_REPOS_NAME))
DB_SERVICE_ENV_PATH		:=	$(MS_DIR)/db-service/.env
