#!/bin/bash
# Version 1.0
# Send Fail2ban notifications using a Telegram Bot

# Add to the /etc/fail2ban/jail.conf:
# [sshd]
# ***
# action  = iptables[name=SSH, port=22, protocol=tcp]
#                       telegram

# Create a new file in /etc/fail2ban/action.d with the following information:
# [Definition]
# actionstart = /etc/fail2ban/scripts/send_telegram_notif.sh -a start
# actionstop = /etc/fail2ban/scripts/send_telegram_notif.sh -a stop
# actioncheck =
# actionban = /etc/fail2ban/scripts/send_telegram_notif.sh -n <name> -b <ip>
# actionunban = /etc/fail2ban/scripts/send_telegram_notif.sh -n <name> -u <ip>
#
# [Init]
# init = 123

# Telegram BOT Token
telegramBotToken='telegram-bot-token'

# Telegram Chat ID
telegramChatID='telegram-chat-id'

function talkToBot() {
        message=$1
        curl -s -X POST https://api.telegram.org/bot${telegramBotToken}/sendMessage -d text="${message}" -d chat_id=${telegramChatID} > /dev/null 2>&1
}

if [ $# -eq 0 ]; then
        echo "Usage $0 -a ( start || stop ) || -b \$IP || -u \$IP"
        exit 1;
fi

while getopts "a:n:b:u:" opt; do
        case "$opt" in
                a)
                        action=$OPTARG
                ;;
                n)
                        jail_name=$OPTARG
                ;;
                b)
                        ban=y
                        ip_add_ban=$OPTARG
                ;;
                u)
                        unban=y
                        ip_add_unban=$OPTARG
                ;;
                \?)
                        echo "Invalid option. -$OPTARG"
                        exit 1
                ;;
        esac
done

if [[ ! -z ${action} ]]; then
        case "${action}" in
                start)
                        talkToBot "Fail2ban has been started"
                ;;
                stop)
                        talkToBot "Fail2ban has been stopped"
                ;;
                *)
                        echo "Incorrect option"
                        exit 1;
                ;;
        esac
elif [[ ${ban} == "y" ]]; then
        talkToBot "[${jail_name}] The IP: ${ip_add_ban} has been banned"
        exit 0;
elif [[ ${unban} == "y" ]]; then
        talkToBot "[${jail_name}] The IP: ${ip_add_unban} has been unbanned"
        exit 0;
else
        info
fi
