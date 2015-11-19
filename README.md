#DOCKER DRUPAL 8 RELEASE

Image includes <b>Drupal 8.0.0 release</b>, <b>drush 8.0.0-rc4</b> and <b>git</b>. It runs on port 8080 therefore to load the application: <b>localhost:8080</b>

You will need docker-compose to be installed in order to use the following scripts:

- "start.sh" to build the image and launch web and db containers.
- "recreate.sh" to delete current containers and recreate them.
- "install.sh" <b>after install or recreate</b> to drupal standard profile quick install.

 

