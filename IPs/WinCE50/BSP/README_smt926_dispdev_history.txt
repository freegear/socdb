[README]

## SkyWalkerDISPD: Display device driver for SkyWalker(SYSTEM)

* History

- SkyWalkerDISPD ver 0.0 

	1. SMDK2440's display device driver -> SkyWalkerDISPD check & change file name
	2. compile check (build -> sysgen -> makeimg)
	
- SkyWalkerDISPD ver 0.5

	1. convention 변경
	2. registry에서 frame buffer address load 수정.(platform/../platform.reg or .bib file)
	3. registry에서 HWC buffer address load 수정.(platform/../platform.reg or .bib file)
	4. sources 잘못된 부분 수정
	5. compile check (build -> sysgen -> makeimg)
	6. 쓸데없는 global 변수 GPE child class 멤버로 추가
	
	
* todo
	
- SkyWalkerDISPD ver 0.0 

	1. LCD sync interface 초기화 부분 추가할 것
	2. HW cursor 추가할 것
	
- SkyWalkerDISPD ver 0.5
	1. HWC interface 보강 필요
	2. CSP의 LCD register header 이름충돌 막을 것
	3. 소스 검증 필요
		

* notice

	절대 porting 수준을 넘지 말것, 구조변경 금지