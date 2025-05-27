## How to Setup the Project
<h4> 1. Clone the migration folder </h4>
<h4> 2. Unzip the migration.zip </h4>
<h4> 3. Install Python == 3.8.5 if not already installed </h4>
<h4> 4. For offline installation follow the installation guides provided in this directory
Python On Remote Machine offline.pdf and offline_installation_of_python_libs.txt files.
</h4>

### For online installation of python follow below steps:

<h3> Installing Python Package Manager PIP </h3>

Before we can install the Python package manager, PIP, we need to enable additional software repositories using the following command:
``` 
sudo yum install epel-release
```
Next, install PIP using the following command:
```
sudo yum install python-pip
```

Finally, confirm that the installation was successful using the following command:
```
pip --version
```

If successful, the system should display the PIP version as well as your current Python version.

<h3> Installing Python 3.8.5 </h3>
Now that we have PIP installed, we can proceed with installing the latest version of Python, 3.8.5. 

Before installing Python you will first need to install the requisite software packages using the following command: 
```
sudo yum install gcc openssl-devel bzip2-devel libffi-devel zlib-devel
```
Once that is done, download the latest version of Python using the wget command as follows:
```
wget https://www.python.org/ftp/python/3.8.5.6/Python-3.8.5.6.tgz
```
Once the file is downloaded, extract it using the following command:
```
tar -xvf Python-3.8.5.6.tgz
```
Once the file has extracted, move into the directory that was created and configure the installation using the following command:
```
./configure 
```
Run the following command:
```
sudo make
```
Next, build Python using the following command:
```
sudo make altinstall
```
After the installation process has finished, confirm the version using the following command:
```
python3.8.5 --version
```

<h3> Run the below command to install the project dependencies </h3>

```
python3 pip install -r requirements.txt
```