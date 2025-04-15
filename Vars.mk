# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Vars.mk                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cpoulain <cpoulain@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/14 15:23:07 by cpoulain          #+#    #+#              #
#    Updated: 2025/04/14 18:20:27 by cpoulain         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Commands

RM					:=	/usr/bin/rm -f
ECHO				:=	/usr/bin/echo
DC					:=	docker-compose

# Repos

ORG_URL				:=	git@github.com:ftpreavis

# Infrastructure

INFRA_DIR			:=	infra
INFRA_REPOS			:=	$(ORG_URL)/infra.git


# Microservices

MS_DIR				:=	services
MS_REPOS_NAME		:=	gateway-service \
						auth-service \
						user-service \
						tournament-service \
						notification-service \
						matchmaking-service \
						chat-service \
						lobby-service
MS_FOLDERS			:=	$(addprefix $(MS_DIR)/, $(MS_REPOS_NAME))

# Scripts

SCRIPTS_DIR			:=	scripts
