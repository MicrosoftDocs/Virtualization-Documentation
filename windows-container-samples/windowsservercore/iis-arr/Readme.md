## IIS Application Request Routing ##

1. Run a couple of IIS upstream servers
```
	docker run -d --name web1 -h web1 microsoft/iis ping -t localhost
	docker run -d --name web2 -h web2 microsoft/iis ping -t localhost
	docker run -d --name web3 -h web3 microsoft/iis ping -t localhost
```

2. Run IIS AAR container image...
	 
	 Note that the IIS ARR config is passed in as JSON via the parameter serverfarms.
	 Also the container is linked to all the three webservers created before via --link.
```
	docker run -d -e serverfarms="[{'name':'MaxFarm','servers':[{'address':'web1'}, {'address':'web2'}, {'address':'web3'}]}]" --link web1 --link web2 --link web3 -p 80:80 knom/iis-arr
```

Sample JSON format:
```
  [
	{
		"name":"Maxtest123",
		"servers":[
			{"address":"server-a"},
			{"address":"server-b"},
			{"address":"server-c"}
		]
	},
	{
		"name":"Maxtest456",
		"servers":[
			{"address":"server-d"},
			{"address":"server-e"}
		]
	}
  ]
```

### Note ###
When passing the JSON into the docker run command, all double quotes (") need to be replaced with single quotes (').
Also everything needs to be one line.