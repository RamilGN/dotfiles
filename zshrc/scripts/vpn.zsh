# host www.speedtest.net
# www.speedtest.net.cdn.cloudflare.net has address 104.18.202.232
# www.speedtest.net.cdn.cloudflare.net has address 104.18.203.232

# host
# api.openai.com has address 104.18.6.192
# api.openai.com has address 104.18.7.192

nmcli connection modify {name} connection.autoconnect true
nmcli connection modify {name} connection.secondaries {name}
nmcli connection modify {name} +ipv4.routes
        # chat.openai
        \ 104.18.37.228
        # api.openai
        \ 104.18.6.192
        \ 104.18.7.192
        # speedtest
        \ 104.18.202.232
        \ 104.18.203.232
