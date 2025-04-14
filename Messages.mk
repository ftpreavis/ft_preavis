# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Messages.mk                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cpoulain <cpoulain@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/14 16:11:15 by cpoulain          #+#    #+#              #
#    Updated: 2025/04/14 17:23:40 by cpoulain         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Messages

MSG_SETTING_UP			:=	"\n📦\t\t$(TERM_BLUE)Setting up %-20s📦\n"

MSG_ALREADY_CLONED		:=	"\n\t✅ $(TERM_YELLOW)%s already exists.$(TERM_RESET)"
MSG_CLONING				:=	"\n\t✅ $(TERM_YELLOW)Cloning %s ...$(TERM_RESET)"
MSG_DONE_CLONING		:=	"\n\t✅ $(TERM_GREEN)Done cloning %s !$(TERM_RESET)\n"

MSG_RM_DIR				:=	"\t❌  $(TERM_RED) Removed $(TERM_YELLOW)\"%s\"$(TERM_RED) directory.$(TERM_RESET)\n"
