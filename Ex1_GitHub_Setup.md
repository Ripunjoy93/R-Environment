### Git Setup from R Studio to connect with GitHub

In this busy life, version control become an essential part for development or analysis or projects to keep a track and to collaborate with team members. Here I am going to show the steps to setup **Git** with RStudion and to connect with **GitHub**. I am configuring all the things in Windows 10 : 64 bit.

*Though RStudio supports two open source version control systems : Git and Subversion(SVN). I will be focusing on Git*

**Pre-requisities :** 
* Git : Install Git and set it to the $PATH. [Know more about Git installation](https://git-scm.com/) 
* GitHub : Create an account in GitHub. [Click Here](https://github.com/)

**Setup steps :** *Before that create a RProject*  
1. Activate Git on your sytem by following steps :
   * From RStudio, **Tools -&gt; Version Control** and select **Git**
   * go-to **Tools -&gt; Global Options** 
   * Click on **Git/SVN** 
   * Select(tick) *Enable Version Control Interface for RStudio Projects* 
   * Make sure PATH to the **Git executable** is correct: eg: */usr/bin/git* (path where you installed git)
   * Now click on the button **Create RSA Key** 
   * Now a window will pop-up, close the window. Click **View public key**. Copy the key and close the pop-up window. 
   * Apply changes and save OK. 
2. Connect to GitHub using RSA public Key 
   * Here you need to have a GitHub account. If you don't have create one.
   * Open your account setting.  Click on **SSH keys**. Click on **Add SSH key** and paste and save the   `public SSH` key your copied from *RStudio*.

3. Setting your username and email in Git. [View More](https://help.github.com/articles/setting-your-username-in-git/)
   * You can set-up your user.name and email for all the repositories (or for single repository) 
   * go-to : **Tools -&gt; Shell** = It will open a command promt in your current project path. 
   * for all repositories :  
   ```git config --global user.email "abcd@domain.com"```    
   ```git config --global user.name "Your Name"``` 
  * for current repository :  
  ```bash   git config user.email "abcd@domain.com"```  
  ```git config user.name "Your Name"``` 
  * check if it is set up correctly or not by - ```git config --list```

**Creating a New Git Project and connect it to Git and Github :**   
1. After the above steps, lets create a new project **File -&gt; New Project**. Select the directory for the project and `tick` the `Create a git repository` check box. `Don't forget to set up the user.name and email for current project if you didn't set it up globally`
2. Create a new RScript.R, or Rmarkdown or notebook. **File -&gt; New File -&gt; R Script**. Write your code in the file.
3. Go-to **Tools -&gt; Version Control -&gt; History**. Check the **Changes and History** tabs. You will find your R Script there.
4. First lets commit to the local computer repsitory. Select the script you want to commit (it will turn to a green `A`). Write the commit message and commit it. You can check if in *History* about this commit in the same way described in point 3. If you change the file or its code. You can find it in *Changes* and can commit again.
5. Now we will link the R-project to github and **push** the **commited** changes to GitHub. `Go through the git documentation to get familiar with different concepts`
    * Create a new repository in GitHub. Let **My First Projct**. Copy the url `eg:https://github.com/UserName/My-First-Project.git`
    * Goto **Tools -> Shell** (it will take you to the local project path in command prompt)
    * Add remote github repository to your local repository: ```git remote add origin https://github.com/UserName/My-First-Project.git```
    * Verify the remote: ```git remote -v```.
    * Now you can also configure you GitHub url once u added : ```git config remote.origin.url https://github.com/UserName/Changing-Project-Name.git```
    * Pull the GitHub remote repo to local: ```git pull origin master``` (`you can change the branch name master to some other brach`: for all this read the git documentation)
    * Push the commited changes to GitHub: ```git push origin master```
    * Now you will be able to see your R Script in GitHub
> Go through this [link](https://gist.github.com/blackfalcon/8428401) while working with git and GitHub if there is some confusion.

**Clone an existing GitHub project to RStudio :**
   * RStudio, go-to **New Project -> Version Control**
   * In *Clone Git Repository* enter GitHub repository URL. Checkout.
   * Go-to **Tools -> Shell**
   * ``git config remote.origin.url https://github.com/UserName/Project-Name.git```
   * Now you are ready to GO.
 > This is always a better way to make changes to GitHub project. First create a repository in GitHub then clone it rather then Separety creating a R project as well as GitHub repository and then linking them.
