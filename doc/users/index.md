# Create User

There are 3 ways to create a user.

## 1. New user form

* Click the `New User` button. ![](img/new-user-click.png)

* Fill the form and click the `Save` button. ![](img/create-from-dashboard-form.png)

## 2. Import from csv or xls files

* Click the `Import Users From CSV or XLS files` button. ![](img/new-user-import-csv-or-xls.png)

* Choose file that you want to upload, fill the form and click `Import User List` button. ![](img/upload-user.png)


## 3. Over the API

* Click the `Create User Over API` button. ![](img/new-user-from-api-click.png)

* Grab your authentication token. ![](img/grab-your-token.png)

* POST to `{your_domain}/api/v1/users` with post data `user`. 
  Example post data: 
  
  ```bash
  curl -i -H "Authorization: Token token= uNKTLDyHsTF1xHTqU_jX " -X POST -d "user[name]=API User" -d "user[email]=email@api.com" -d "user[tag_list]= tester, new user" -d "attributes[phone]=+123456456" -d "attributes[custom_key]=custom_value" http://your-domain.com/api/v1/users
  ```