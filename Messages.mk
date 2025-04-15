# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Messages.mk                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cpoulain <cpoulain@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/14 16:11:15 by cpoulain          #+#    #+#              #
#    Updated: 2025/04/15 17:38:11 by cpoulain         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# ---------------------------------------------------------------------------- #
#                                   Messages                                   #
# ---------------------------------------------------------------------------- #

# ------------------------------------ Git ----------------------------------- #

MSG_SETTING_UP			:=	"\n📦\t\t$(TERM_BLUE)Setting up %-20s📦\n"

MSG_ALREADY_CLONED		:=	"\n\t✅ $(TERM_YELLOW)%s already exists.$(TERM_RESET)"
MSG_CLONING				:=	"\n\t🔨 $(TERM_YELLOW)Cloning %s ...$(TERM_RESET)"
MSG_DONE_CLONING		:=	"\n\t✅ $(TERM_GREEN)Done cloning %s !$(TERM_RESET)\n"

MSG_UPDATING			:=	"\n\t🔨 $(TERM_YELLOW)Updating %s ...$(TERM_RESET)"
MSG_DONE_UPDATING		:=	"\n\t✅ $(TERM_GREEN)Done updating %s !$(TERM_RESET)\n"
MSG_IGNORING			:=	"\n\t🚧 $(TERM_YELLOW)%s does not exists, ignoring...$(TERM_RESET)"

MSG_STATUS_DIR			:=	"\n\t📁 $(TERM_BLUE) Checking %s status...$(TERM_RESET)"

MSG_RM_DIR				:=	"\t❌  $(TERM_RED) Removed $(TERM_YELLOW)\"%s\"$(TERM_RED) directory.$(TERM_RESET)\n"

# ---------------------------------- Docker ---------------------------------- #

MSG_DC_MODE					:=	"\n\t🐳$(TERM_BLUE) Running compose using: %s$(TERM_RESET)\n"
MSG_DOCKER_UP				:=	"\n\t🐳$(TERM_BLUE) Starting and building projects containers...$(TERM_RESET)"
MSG_DOCKER_UP_DONE			:=	"\n\t🐳$(TERM_GREEN) Done starting containers !$(TERM_RESET)"
MSG_DOCKER_DOWN				:=	"\n\t🐳$(TERM_RED) Shutting down containers...$(TERM_RESET)"
MSG_DOCKER_DOWN_DONE		:=	"\n\t🐳$(TERM_GREEN) Done shutting down containers !$(TERM_RESET)"

# ---------------------------------- Scripts --------------------------------- #

MSG_VAULT_SEEDING		:=	"\n\t🔨 $(TERM_YELLOW)Seeding vault...$(TERM_RESET)"
MSG_DONE_VAULT_SEEDING	:=	"\n\t✅ $(TERM_GREEN)Done seeding vault !$(TERM_RESET)\n"
