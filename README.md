# DNS sinkhole

Install unbound dns

Upate the root.hints, this can be in a cron every 6 months (`0 0 1 */6 *`)

`wget http://www.internic.net/domain/named.root -O /var/lib/unbound/root.hints`

Edit the unbound.conf and adjust settings according to your needs

You can add or remove more lists in the denylist.sh run in a cron every week (`0 2 * * 1`)

Install some ad blocker in your browser for better results

I have this running in a old raspberry pi with [dietpi](https://dietpi.com/) and works fine
