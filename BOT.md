
CraftBot is available at the internal #craftbot channel:

<img src="https://github.com/latcraft/event-manager/raw/master/src/main/docs/images/bot/craftbot_help.png">

All the `publish`/`send` commands will happen in the context of the future event and they require data from the 
`events.json` file in <https://github.com/latcraft/website/>.

The `list`/`copy` commands are independent of the event context.

Since it is deployed in passive mode (AWS Lambda), if the bot is not used for some time, you may get a timeout when 
executing first couple of commands, but it warms up after that and response should be fast.

Examples of bot communication:

<img src="https://github.com/latcraft/event-manager/raw/master/src/main/docs/images/bot/craftbot_list_venues.png">

<img src="https://github.com/latcraft/event-manager/raw/master/src/main/docs/images/bot/craftbot_publish_cards.png">

<img src="https://github.com/latcraft/event-manager/raw/master/src/main/docs/images/bot/craftbot_send_campaign.png">

<img src="https://github.com/latcraft/event-manager/raw/master/src/main/docs/images/bot/craftbot_copy_contacts.png">

<img src="https://github.com/latcraft/event-manager/raw/master/src/main/docs/images/bot/craftbot_help.png">
