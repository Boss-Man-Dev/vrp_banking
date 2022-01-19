resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

dependency "vrp"

ui_page "cfg/html/index.html"

server_script {
    "@vrp/lib/utils.lua",
	"vrp_s.lua"
}

client_script {
	"@vrp/lib/utils.lua",
	'client.lua'
}

files {
	"cfg/cfg.lua",
	-- HTML
	'cfg/html/index.html',
	-- css
	'cfg/html/css/ads.css',
	'cfg/html/css/dashboard.css',
	'cfg/html/css/form.css',
	'cfg/html/css/info.css',
	'cfg/html/css/login.css',
	'cfg/html/css/nav.css',
	'cfg/html/css/style.css',
	-- JS
	'cfg/html/js/listener.js',
	'cfg/html/js/config.js',
	--images
    'cfg/html/assets/ad_1.png',
	'cfg/html/assets/ad_2.png',
	'cfg/html/assets/card_img.png',
	'cfg/html/assets/Default_user.png',
	'cfg/html/assets/placeholder.png',
}
