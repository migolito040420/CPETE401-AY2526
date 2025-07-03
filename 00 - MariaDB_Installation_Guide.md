### **How to Install MariaDB on Windows**

This guide will walk you through the process of installing MariaDB on your Windows computer.

**Step 1: Download the MariaDB Installer**

First, you need to download the official MariaDB installer.

1.  Go to the MariaDB downloads page: [https://mariadb.org/download/](https://mariadb.org/download/)
2.  Select the latest stable version of MariaDB.
3.  Choose the "MSI Package" for Windows.
4.  Download the installer file (it will have a `.msi` extension).

**Step 2: Run the Installer**

Locate the downloaded `.msi` file in your "Downloads" folder and double-click it to begin the installation. If Windows prompts you for permission to make changes to your device, click "Yes".

**Step 3: Accept the License Agreement**

The first screen of the installer is the End-User License Agreement.

- **Action:** Check the box next to "I accept the terms in the License Agreement" and click the "Next" button.

**Step 4: Choose Components**

This screen allows you to select which features of MariaDB you want to install. For most users, the default selection is sufficient.

- **Action:** Leave the default components selected and click "Next".

**Step 5: Set the Root Password**

This is a crucial step where you will set the password for the `root` (administrator) user.

- **Action:**
  - Enter a strong password in the "New root password" field and enter the same password in the "Confirm" field. **Remember this password, as you will need it to access your databases.**
  - For security reasons, it is recommended to leave the "Enable access from remote machines for 'root' user" option unchecked unless you have a specific need to connect to the database from another computer.
  - Click "Next".

**Step 6: Configure Database Properties**

In this step, you will configure the MariaDB service.

- **Action:**
  - Keep the "Install as service" option checked. This will ensure MariaDB runs automatically in the background when your computer starts.
  - Leave the default port as `3306`, unless you have another program (like MySQL) that is already using this port.
  - Click "Next".

**Step 7: Ready to Install**

The installer now has all the necessary information to proceed with the installation.

- **Action:** Click the "Install" button.

**Step 8: Installation Complete**

The installation process will take a few moments. Once it is finished, you will see the final screen.

- **Action:** Click the "Finish" button to close the installer.

---

### **How to Run MariaDB in the Terminal**

After the installation is complete, you can connect to your MariaDB server using the command prompt.

**Step 1: Open the Command Prompt**

You can open the Command Prompt by searching for "cmd" in the Windows Start Menu.

**Step 2: Navigate to the MariaDB `bin` Directory**

The MariaDB command-line tools are located in the `bin` directory of your MariaDB installation folder. By default, this is usually:

`C:\Program Files\MariaDB [version]\bin`

In the command prompt, type the following command and press Enter (replace `[version]` with your installed version number):

```
cd "C:\Program Files\MariaDB [version]\bin"
```

**Step 3: Connect to the MariaDB Server**

To connect to the MariaDB server, use the `mysql` command. You will need to provide the username (`root`) and specify that you want to enter a password.

Type the following command and press Enter:

```
mysql -u root -p
```

**Step 4: Enter the Root Password**

You will be prompted to enter the password for the `root` user. This is the password you created during Step 5 of the installation.

Type your password and press Enter. **Note that you will not see any characters as you type the password.** This is a security feature.

**Step 5: You are Connected!**

If the password is correct, you will be connected to the MariaDB server, and you will see the MariaDB monitor prompt, which looks like this:

```
MariaDB [(none)]>
```

You can now start running SQL commands to create and manage your databases. To exit the MariaDB monitor, type `exit` and press Enter.
