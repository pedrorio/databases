change in each .cgi file, the config dataclass attributes:
```
username
password
database
website_root
```

inside this directory, sftp this folder to ~/web/sibd/:
```
sftp istxxx@xxxxx
```
then
```
put -rf ./* ~/web/sibd/
bye
```
then
```
ssh istxxx@xxxxx
```
then
```
sh ~/web/sibd/run.sh 
```
finnaly, see the webapp in 
```
https://web2.tecnico.ulisboa.pt/istxxxxxx/sibd/index.cgi
```