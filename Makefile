# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cpoulain <cpoulain@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/14 15:23:12 by cpoulain          #+#    #+#              #
#    Updated: 2025/04/14 17:21:28 by cpoulain         ###   ########.fr        #
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

all: clone-all pull-all restart

clone-all:
	@printf $(MSG_SETTING_UP) Infra
	@if [ ! -d "$(INFRA_DIR)" ]; then \
		printf $(MSG_CLONING) Infra; \
		git clone $(INFRA_REPOS) $(INFRA_DIR) > /dev/null 2>&1; \
		printf $(MSG_DONE_CLONING) Infra; \
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

reset: down
	@printf ${MSG_RM_DIR} $(MS_DIR)
	@${RM} -r $(MS_DIR)
	@printf ${MSG_RM_DIR} $(INFRA_DIR)
	@$(RM) -r $(INFRA_DIR)

.PHONY:	all up down restart logs vault-seed reset clone-all pull
