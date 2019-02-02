<p align="center">
 *buraya logo gelecek*
 </p>
 
<br>
<p align="center">
    A simple dockerized Rails app,<br> 
  to manage your emails and campaigns with taggings!
</p>

# Smart-Emailing

[![Code Climate](https://codeclimate.com/github/mojilala/smart-emailing/badges/gpa.svg)](https://codeclimate.com/github/mojilala/smart-emailing) ![](https://img.shields.io/github/stars/svtek/smart-emailing.svg) ![](https://img.shields.io/github/forks/svtek/smart-emailing.svg) ![](https://img.shields.io/github/tag/svtek/smart-emailing.svg) ![](https://img.shields.io/github/issues/svtek/smart-emailing.svg) ![](https://img.shields.io/github/contributors/svtek/smart-emailing.svg) ![](https://img.shields.io/github/license/svtek/smart-emailing.svg)

There are two important factors for Email marketing. Manage whole process effectively and analysis results easily. If you follow these two factor, your email campaigns will be more successful. Because of **flexible time management**, **less energy** and **knowledge of right targets**. So, guess which tool focused on these two important factors for the good of community? Of course Smart-Emailing did it! You can personalize your emails and use CRM for your emails or inbox. And you can do all of this with a simple **dockerized rails app**!

<img src="https://github.com/mesutgulecen/smart-emailing/blob/master/doc/assets/campaigns_ss.png" width="900" height="500">

# 🚻 For whom?

:vertical_traffic_light: If you need to send **automatic** emails,<br>
:rainbow: If you need to create and manage email **campaigns with taggings**,<br>
 🔍 If you need to **track** your campaigns and **analyse** your results,<br>
 📊 If you need to **monitoring** your activities,<br>
 📑 If you want to use email **templates**,<br>
 🕵️ If you need to add tags or custom data and **categorize users**,<br>
 💯 And if you want to do all of this **easily**,<br>

Then you're at the right place. Because **Smart-Emailing builded for you!** :tada:

# ☑ Features
:arrow_forward: **CRM:**<br>
🔸 Filter users with advanced search such as tags, previous campaign, campaign status or email open status<br>
🔸 Import users from csv (any column name will become custom data)<br>
🔸 Export filtered users to csv and xlsx<br>
🔸 Add tags, custom data to users<br>
🔸 Create a campaign from filtered user result<br>

:arrow_forward: **Campaign Management:**<br>
🔸 Create a campaign from filtered user result<br>
🔸 Campaign's tagging, user-campaign tagging<br>
🔸 Email templates<br>
🔸 Send campaign from any service provider sendgrid, AWS (Send Newsletters 100x cheaper)<br>

:arrow_forward: **Campaign Results:**<br>
🔸 Email stats from sendgrid<br>

:arrow_forward: **Inbox Management:**<br>
🔸 Email inbox parsing and email macthing<br>
🔸 Delete, archive emails from inbox<br>
🔸 Add tags, and campaign-user tags directly from inbox<br>
🔸 Quick template responses from directly from inbox<br>

:arrow_forward: **Email**<br>
🔸 Template emails<br>
🔸 Simple access to any custom fields about the user<br>
🔸 Write any Ruby code<br>
🔸 Support multiple SMTP option<br>
🔸 Support IMAP option<br>

# 🔱 Installation

### 1- Install Docker

:droplet: Install the most recent version of the Docker Engine for your platform using the 🔗[official Docker releases](http://docs.docker.com/engine/installation/), which can also be installed using:

```bash
wget -qO- https://get.docker.com/ | sh
```

### 2- Install Docker Compose

:droplet: Install docker compose from the 🔗[official page](https://docs.docker.com/compose/install/).    

```bash
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

### 3- Database Settings

:droplet: You can use `sqlite`, `postgresql`, `mysql` and `sql server`.

:droplet: Create a database.yml and link it in the docker-compose.yml

### 4- Create data folders

```bash
mkdir -p /datadrive/csv-files && mkdir -p /datadrive/data/db && mkdir -p /datadrive/data/redis && mkdir -p /datadrive/data/nginx && mkdir -p /datadrive/working-dir 
```

### 5- Create a database.yml

:droplet: Sqlite 

```bash
cd /datadrive && wget https://raw.githubusercontent.com/mojilala/smart-emailing/master/config/database.yml
```

:droplet: MySQL

```bash
cd /datadrive && wget https://raw.githubusercontent.com/mojilala/smart-emailing/master/config/database_mysql.example.yml
```

:droplet: PostgreSQL

```bash
cd /datadrive && wget https://raw.githubusercontent.com/mojilala/smart-emailing/master/config/database_postgresql.example.yml
```
:droplet: Sql SERVER

```bash
cd /datadrive && wget https://raw.githubusercontent.com/mojilala/smart-emailing/master/config/database_azure_sql.example.yml
```

### 6- Create nginx settings

```bash
cd /datadrive/data/nginx && wget https://raw.githubusercontent.com/mojilala/smart-emailing/master/nginx/my_proxy.conf
```

### 7- Get docker-compose.yml

:droplet: Download

```bash
cd /datadrive/working-dir && wget https://raw.githubusercontent.com/mojilala/smart-emailing/master/docker-compose.yml
```

:droplet: Update environment variables with your settings https://github.com/mojilala/smart-emailing/blob/master/docker-compose.yml#L34

### 8- Run

```bash
sudo docker-compose build
sudo docker-compose run web rake db:migrate
sudo docker-compose up -d
```
### 9- Configure Sendgrid

:droplet: If you are using sendgrid as email provider, you will be able to
get status of sent emails.


:droplet: Go to: https://app.sendgrid.com/settings/mail_settings ->
  Event Notification -> `<yourhost.com>`/campaigns/event_receiver

# 💝 Contributing

We are so grateful for all volunteers like you for contributions. And we are so exciting to welcome your contributions!🙏 But first, please take a moment to read our 🔗[contributing guild](https://github.com/svtek/smart-emailing/blob/master/CONTRIBUTING.md) to make the contribution process effective for everyone. Our 🔗[issue tracker](https://github.com/svtek/smart-emailing/issues) is the preferred channel for bug reports, features requests and submitting pull requests. After that, you can start to fork!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

🔎 But before opening a feature request, please take a moment to find out whether your idea fits with the scope and aims of the project. It's up to you to make a strong case to convince the project's developers of the merits of this feature. So, you can provide as much detail and context as possible.

# :muscle: Team

| [<img src="https://pbs.twimg.com/profile_images/508440350495485952/U1VH52UZ_200x200.jpeg" width="100px;"/>](https://twitter.com/sahinboydas) <br/> [Sahin Boydas](https://twitter.com/sahinboydas)<br/><sub>Creator</sub><br/> [![LinkedIn][1.1]][1] | [<img src="https://avatars1.githubusercontent.com/u/989759?s=460&v=4" width="100px;"/>](https://github.com/muhammet) <br/>[Muhammet](https://github.com/muhammet)<br/><sub>Developer</sub><br/> [![Github][2.1]][2] | [<img src="https://avatars1.githubusercontent.com/u/8470005?s=460&v=4" width="100px;"/>](https://github.com/sadikay)  <br/>[Sadik](https://github.com/sadikay)<br/><sub>Developer</sub><br/> [![Github][3.1]][3] |
| - | - | - | 

[1.1]: https://www.kingsfund.org.uk/themes/custom/kingsfund/dist/img/svg/sprite-icon-linkedin.svg (linkedin icon)
[1]: https://www.linkedin.com/in/sahinboydas
[2.1]: http://i.imgur.com/9I6NRUm.png (github.com/muhammet)
[2]: http://www.github.com/muhammet
[3.1]: http://i.imgur.com/9I6NRUm.png (github.com/sadikay)
[3]: http://www.github.com/sadikay


# 🎓 License

This program is a free and open source software. You can redistribute it and/or modify it under the terms of the license provided in the 🔗[LICENSE](LICENSE) file. Use of this software is subject to important terms and conditions as set forth in the 🔗[LICENSE](LICENSE) file.

# 🔍 Acknowledgement

If you liked Smart-Emailing app, please give us a "**Star** :star:". Your support is what keep us moving forward and delivering happiness to you! Thank's a million, you're our *Clark Kent*/*Kara Danvers*! In case of any questions or concerns, feel free to contact us anytime. :blush:
