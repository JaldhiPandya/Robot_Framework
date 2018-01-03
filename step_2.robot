*** Settings ***
Library     RequestsLibrary
Library     XML
Library     Collections

***Keyword***
Valid Login
	${root}             Parse XML       both_valid.xml
    ${User_name}=       Get Element     ${root}     Username
    ${Password}=        Get Element     ${root}     Password
    @{Cred}             Create list     ${User_name.text}  ${Password.text}
	[Return]			@{Cred}

Invalid Login
	${root}             Parse XML       both_invalid.xml
    ${User_name}=       Get Element     ${root}     Username
    ${Password}=        Get Element     ${root}     Password
    @{Cred}             Create list     ${User_name.text}  ${Password.text}
    [Return]            @{Cred}

Valid Username
	${root}             Parse XML       Invalid_password.xml
    ${User_name}=       Get Element     ${root}     Username
    ${Password}=        Get Element     ${root}     Password
    @{Cred}             Create list     ${User_name.text}  ${Password.text}
    [Return]            @{Cred}

Valid Password
    ${root}             Parse XML       Invalid_username.xml
    ${User_name}=       Get Element     ${root}     Username
    ${Password}=        Get Element     ${root}     Password
    @{Cred}             Create list     ${User_name.text}  ${Password.text}
    [Return]            @{Cred}


***Test Cases***
TestCase_1:
	[Documentation]		Valid Username and Valid Password
	[Tags]				Positive Test Case
	@{both_valid}		Valid Login
	Create Session   	github    https://api.github.com   verify=True   auth=@{both_valid}
    ${resp}=  			get Request    github  /user
    log to console    	\n=> Response Status Code: ${resp.status_code}
    log to console    	\n=> Response Message: ${resp.text}
	Should Be Equal As Strings      ${resp.status_code}     200

TestCase_2:
	[Documentation]		Invalid Username and Invalid Password
	[Tags]				Negative Test Case
    @{both_Invalid}   	Invalid Login
    Create Session   	github    https://api.github.com   verify=True   auth=@{both_invalid}
    ${resp}=  			get Request    github  /user
    log to console    	\n=> Response Status Code: ${resp.status_code}
    log to console    	\n=> REsponse Message: ${resp.text}
	Should Be Equal As Strings      ${resp.status_code}     200

TestCase_3:
	[Documentation]			Valid Username and Invalid Password
	[Tags]					Negative Test Case
    @{valid_username}     	Valid Username
    Create Session      	github    https://api.github.com   verify=True   auth=@{valid_username}
    ${resp}=            	get Request    github  /user
    log to console      	\n=> Response Status Code: ${resp.status_code}
    log to console      	\n=> REsponse Message: ${resp.text}
    Should Be Equal As Strings      ${resp.status_code}     200

TestCase_4:
	[Documentation]			Invalid Username and Valid Password
	[Tags]					Negative Test Case
    @{valid_password}       Valid Password
    Create Session          github    https://api.github.com   verify=True   auth=@{valid_password}
    ${resp}=                get Request    github  /user
    log to console          \n=> Response Status Code: ${resp.status_code}
    log to console          \n=> REsponse Message: ${resp.text}
    Should Be Equal As Strings      ${resp.status_code}     200



