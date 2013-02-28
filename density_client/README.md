This package provide density test tools for rabbitmq service

the main steps are:
1.Modify the config.yml file to set for your local environment

2.Create rabbit instances by 
  client create_serivces

3.Upload test client to deas nodes by
  client upload

4.Preload data to rabbitmq services
  client preload

5.Run client to push/pop message to rabbit services
  client start

6.Stop test client and gather the test data
  client stop

7.Clear all the test client apps on deas
  client clear
