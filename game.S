
game.bin:     file format elf32-i386


Disassembly of section .text:

080480b4 <wait_for_interrupt>:
 80480b4:	55                   	push   %ebp
 80480b5:	89 e5                	mov    %esp,%ebp
 80480b7:	f4                   	hlt    
 80480b8:	5d                   	pop    %ebp
 80480b9:	c3                   	ret    

080480ba <enable_interrupt>:
 80480ba:	55                   	push   %ebp
 80480bb:	89 e5                	mov    %esp,%ebp
 80480bd:	fb                   	sti    
 80480be:	5d                   	pop    %ebp
 80480bf:	c3                   	ret    

080480c0 <disable_interrupt>:
 80480c0:	55                   	push   %ebp
 80480c1:	89 e5                	mov    %esp,%ebp
 80480c3:	fa                   	cli    
 80480c4:	5d                   	pop    %ebp
 80480c5:	c3                   	ret    

080480c6 <timer_event>:
 80480c6:	55                   	push   %ebp
 80480c7:	89 e5                	mov    %esp,%ebp
 80480c9:	a1 40 bb 04 08       	mov    0x804bb40,%eax
 80480ce:	83 c0 01             	add    $0x1,%eax
 80480d1:	a3 40 bb 04 08       	mov    %eax,0x804bb40
 80480d6:	5d                   	pop    %ebp
 80480d7:	c3                   	ret    

080480d8 <set_fps>:
 80480d8:	55                   	push   %ebp
 80480d9:	89 e5                	mov    %esp,%ebp
 80480db:	8b 45 08             	mov    0x8(%ebp),%eax
 80480de:	a3 44 bb 04 08       	mov    %eax,0x804bb44
 80480e3:	5d                   	pop    %ebp
 80480e4:	c3                   	ret    

080480e5 <get_fps>:
 80480e5:	55                   	push   %ebp
 80480e6:	89 e5                	mov    %esp,%ebp
 80480e8:	a1 44 bb 04 08       	mov    0x804bb44,%eax
 80480ed:	5d                   	pop    %ebp
 80480ee:	c3                   	ret    

080480ef <main_loop>:
 80480ef:	55                   	push   %ebp
 80480f0:	89 e5                	mov    %esp,%ebp
 80480f2:	83 ec 28             	sub    $0x28,%esp
 80480f5:	83 ec 0c             	sub    $0xc,%esp
 80480f8:	68 e8 98 04 08       	push   $0x80498e8
 80480fd:	e8 e7 06 00 00       	call   80487e9 <printk>
 8048102:	83 c4 10             	add    $0x10,%esp
 8048105:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 804810c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8048113:	e8 9c ff ff ff       	call   80480b4 <wait_for_interrupt>
 8048118:	e8 a3 ff ff ff       	call   80480c0 <disable_interrupt>
 804811d:	a1 40 bb 04 08       	mov    0x804bb40,%eax
 8048122:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8048125:	75 0a                	jne    8048131 <main_loop+0x42>
 8048127:	e8 8e ff ff ff       	call   80480ba <enable_interrupt>
 804812c:	e9 c3 01 00 00       	jmp    80482f4 <main_loop+0x205>
 8048131:	a1 40 bb 04 08       	mov    0x804bb40,%eax
 8048136:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8048139:	7c 12                	jl     804814d <main_loop+0x5e>
 804813b:	83 ec 08             	sub    $0x8,%esp
 804813e:	6a 38                	push   $0x38
 8048140:	68 f2 98 04 08       	push   $0x80498f2
 8048145:	e8 7e 07 00 00       	call   80488c8 <abort>
 804814a:	83 c4 10             	add    $0x10,%esp
 804814d:	a1 40 bb 04 08       	mov    0x804bb40,%eax
 8048152:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8048155:	e8 60 ff ff ff       	call   80480ba <enable_interrupt>
 804815a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
 804815e:	e8 8b 11 00 00       	call   80492ee <update_keypress>
 8048163:	e9 71 01 00 00       	jmp    80482d9 <main_loop+0x1ea>
 8048168:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 804816b:	ba 89 88 88 88       	mov    $0x88888889,%edx
 8048170:	89 c8                	mov    %ecx,%eax
 8048172:	f7 ea                	imul   %edx
 8048174:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 8048177:	c1 f8 04             	sar    $0x4,%eax
 804817a:	89 c2                	mov    %eax,%edx
 804817c:	89 c8                	mov    %ecx,%eax
 804817e:	c1 f8 1f             	sar    $0x1f,%eax
 8048181:	29 c2                	sub    %eax,%edx
 8048183:	89 d0                	mov    %edx,%eax
 8048185:	89 c2                	mov    %eax,%edx
 8048187:	8d 04 12             	lea    (%edx,%edx,1),%eax
 804818a:	89 c2                	mov    %eax,%edx
 804818c:	89 d0                	mov    %edx,%eax
 804818e:	c1 e0 04             	shl    $0x4,%eax
 8048191:	29 d0                	sub    %edx,%eax
 8048193:	29 c1                	sub    %eax,%ecx
 8048195:	89 c8                	mov    %ecx,%eax
 8048197:	85 c0                	test   %eax,%eax
 8048199:	75 2c                	jne    80481c7 <main_loop+0xd8>
 804819b:	83 ec 0c             	sub    $0xc,%esp
 804819e:	6a 02                	push   $0x2
 80481a0:	e8 e9 09 00 00       	call   8048b8e <query_key>
 80481a5:	83 c4 10             	add    $0x10,%esp
 80481a8:	84 c0                	test   %al,%al
 80481aa:	74 05                	je     80481b1 <main_loop+0xc2>
 80481ac:	e8 ca 0d 00 00       	call   8048f7b <move_left>
 80481b1:	83 ec 0c             	sub    $0xc,%esp
 80481b4:	6a 03                	push   $0x3
 80481b6:	e8 d3 09 00 00       	call   8048b8e <query_key>
 80481bb:	83 c4 10             	add    $0x10,%esp
 80481be:	84 c0                	test   %al,%al
 80481c0:	74 05                	je     80481c7 <main_loop+0xd8>
 80481c2:	e8 d0 0d 00 00       	call   8048f97 <move_right>
 80481c7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 80481ca:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 80481cf:	89 c8                	mov    %ecx,%eax
 80481d1:	f7 ea                	imul   %edx
 80481d3:	c1 fa 05             	sar    $0x5,%edx
 80481d6:	89 c8                	mov    %ecx,%eax
 80481d8:	c1 f8 1f             	sar    $0x1f,%eax
 80481db:	29 c2                	sub    %eax,%edx
 80481dd:	89 d0                	mov    %edx,%eax
 80481df:	6b c0 64             	imul   $0x64,%eax,%eax
 80481e2:	29 c1                	sub    %eax,%ecx
 80481e4:	89 c8                	mov    %ecx,%eax
 80481e6:	85 c0                	test   %eax,%eax
 80481e8:	75 16                	jne    8048200 <main_loop+0x111>
 80481ea:	83 ec 0c             	sub    $0xc,%esp
 80481ed:	6a 04                	push   $0x4
 80481ef:	e8 9a 09 00 00       	call   8048b8e <query_key>
 80481f4:	83 c4 10             	add    $0x10,%esp
 80481f7:	84 c0                	test   %al,%al
 80481f9:	74 05                	je     8048200 <main_loop+0x111>
 80481fb:	e8 dd 0d 00 00       	call   8048fdd <create_new_bullet>
 8048200:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8048203:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 8048208:	89 c8                	mov    %ecx,%eax
 804820a:	f7 ea                	imul   %edx
 804820c:	c1 fa 08             	sar    $0x8,%edx
 804820f:	89 c8                	mov    %ecx,%eax
 8048211:	c1 f8 1f             	sar    $0x1f,%eax
 8048214:	29 c2                	sub    %eax,%edx
 8048216:	89 d0                	mov    %edx,%eax
 8048218:	69 c0 20 03 00 00    	imul   $0x320,%eax,%eax
 804821e:	29 c1                	sub    %eax,%ecx
 8048220:	89 c8                	mov    %ecx,%eax
 8048222:	85 c0                	test   %eax,%eax
 8048224:	75 05                	jne    804822b <main_loop+0x13c>
 8048226:	e8 24 0e 00 00       	call   804904f <create_new_letter>
 804822b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 804822e:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048233:	89 c8                	mov    %ecx,%eax
 8048235:	f7 ea                	imul   %edx
 8048237:	c1 fa 02             	sar    $0x2,%edx
 804823a:	89 c8                	mov    %ecx,%eax
 804823c:	c1 f8 1f             	sar    $0x1f,%eax
 804823f:	29 c2                	sub    %eax,%edx
 8048241:	89 d0                	mov    %edx,%eax
 8048243:	c1 e0 02             	shl    $0x2,%eax
 8048246:	01 d0                	add    %edx,%eax
 8048248:	01 c0                	add    %eax,%eax
 804824a:	29 c1                	sub    %eax,%ecx
 804824c:	89 ca                	mov    %ecx,%edx
 804824e:	85 d2                	test   %edx,%edx
 8048250:	75 05                	jne    8048257 <main_loop+0x168>
 8048252:	e8 df 0e 00 00       	call   8049136 <update_letter_pos>
 8048257:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 804825a:	ba e1 83 0f 3e       	mov    $0x3e0f83e1,%edx
 804825f:	89 c8                	mov    %ecx,%eax
 8048261:	f7 ea                	imul   %edx
 8048263:	c1 fa 03             	sar    $0x3,%edx
 8048266:	89 c8                	mov    %ecx,%eax
 8048268:	c1 f8 1f             	sar    $0x1f,%eax
 804826b:	29 c2                	sub    %eax,%edx
 804826d:	89 d0                	mov    %edx,%eax
 804826f:	89 c2                	mov    %eax,%edx
 8048271:	c1 e2 05             	shl    $0x5,%edx
 8048274:	01 c2                	add    %eax,%edx
 8048276:	89 c8                	mov    %ecx,%eax
 8048278:	29 d0                	sub    %edx,%eax
 804827a:	85 c0                	test   %eax,%eax
 804827c:	75 04                	jne    8048282 <main_loop+0x193>
 804827e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
 8048282:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8048285:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 804828a:	89 c8                	mov    %ecx,%eax
 804828c:	f7 ea                	imul   %edx
 804828e:	c1 fa 05             	sar    $0x5,%edx
 8048291:	89 c8                	mov    %ecx,%eax
 8048293:	c1 f8 1f             	sar    $0x1f,%eax
 8048296:	29 c2                	sub    %eax,%edx
 8048298:	89 d0                	mov    %edx,%eax
 804829a:	69 c0 f4 01 00 00    	imul   $0x1f4,%eax,%eax
 80482a0:	29 c1                	sub    %eax,%ecx
 80482a2:	89 c8                	mov    %ecx,%eax
 80482a4:	85 c0                	test   %eax,%eax
 80482a6:	75 2d                	jne    80482d5 <main_loop+0x1e6>
 80482a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80482ab:	01 c0                	add    %eax,%eax
 80482ad:	83 c0 01             	add    $0x1,%eax
 80482b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
 80482b3:	83 7d e8 1e          	cmpl   $0x1e,-0x18(%ebp)
 80482b7:	7e 07                	jle    80482c0 <main_loop+0x1d1>
 80482b9:	c7 45 e8 1e 00 00 00 	movl   $0x1e,-0x18(%ebp)
 80482c0:	83 ec 0c             	sub    $0xc,%esp
 80482c3:	ff 75 e8             	pushl  -0x18(%ebp)
 80482c6:	e8 0d fe ff ff       	call   80480d8 <set_fps>
 80482cb:	83 c4 10             	add    $0x10,%esp
 80482ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80482d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80482d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80482dc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
 80482df:	0f 8c 83 fe ff ff    	jl     8048168 <main_loop+0x79>
 80482e5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
 80482e9:	74 09                	je     80482f4 <main_loop+0x205>
 80482eb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 80482ef:	e8 f7 05 00 00       	call   80488eb <redraw_screen>
 80482f4:	e9 1a fe ff ff       	jmp    8048113 <main_loop+0x24>

080482f9 <srand>:
 80482f9:	55                   	push   %ebp
 80482fa:	89 e5                	mov    %esp,%ebp
 80482fc:	8b 45 08             	mov    0x8(%ebp),%eax
 80482ff:	a3 48 bb 04 08       	mov    %eax,0x804bb48
 8048304:	5d                   	pop    %ebp
 8048305:	c3                   	ret    

08048306 <rand>:
 8048306:	55                   	push   %ebp
 8048307:	89 e5                	mov    %esp,%ebp
 8048309:	a1 48 bb 04 08       	mov    0x804bb48,%eax
 804830e:	69 c0 35 4e 5a 01    	imul   $0x15a4e35,%eax,%eax
 8048314:	83 c0 01             	add    $0x1,%eax
 8048317:	a3 48 bb 04 08       	mov    %eax,0x804bb48
 804831c:	a1 48 bb 04 08       	mov    0x804bb48,%eax
 8048321:	c1 f8 10             	sar    $0x10,%eax
 8048324:	25 ff 7f 00 00       	and    $0x7fff,%eax
 8048329:	5d                   	pop    %ebp
 804832a:	c3                   	ret    

0804832b <itoa>:
 804832b:	55                   	push   %ebp
 804832c:	89 e5                	mov    %esp,%ebp
 804832e:	83 ec 10             	sub    $0x10,%esp
 8048331:	c7 45 fc 69 bb 04 08 	movl   $0x804bb69,-0x4(%ebp)
 8048338:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
 804833c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 804833f:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048344:	89 c8                	mov    %ecx,%eax
 8048346:	f7 ea                	imul   %edx
 8048348:	c1 fa 02             	sar    $0x2,%edx
 804834b:	89 c8                	mov    %ecx,%eax
 804834d:	c1 f8 1f             	sar    $0x1f,%eax
 8048350:	29 c2                	sub    %eax,%edx
 8048352:	89 d0                	mov    %edx,%eax
 8048354:	c1 e0 02             	shl    $0x2,%eax
 8048357:	01 d0                	add    %edx,%eax
 8048359:	01 c0                	add    %eax,%eax
 804835b:	29 c1                	sub    %eax,%ecx
 804835d:	89 ca                	mov    %ecx,%edx
 804835f:	89 d0                	mov    %edx,%eax
 8048361:	83 c0 30             	add    $0x30,%eax
 8048364:	89 c2                	mov    %eax,%edx
 8048366:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048369:	88 10                	mov    %dl,(%eax)
 804836b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 804836e:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048373:	89 c8                	mov    %ecx,%eax
 8048375:	f7 ea                	imul   %edx
 8048377:	c1 fa 02             	sar    $0x2,%edx
 804837a:	89 c8                	mov    %ecx,%eax
 804837c:	c1 f8 1f             	sar    $0x1f,%eax
 804837f:	29 c2                	sub    %eax,%edx
 8048381:	89 d0                	mov    %edx,%eax
 8048383:	89 45 08             	mov    %eax,0x8(%ebp)
 8048386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804838a:	75 ac                	jne    8048338 <itoa+0xd>
 804838c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804838f:	c9                   	leave  
 8048390:	c3                   	ret    

08048391 <memcpy>:
 8048391:	55                   	push   %ebp
 8048392:	89 e5                	mov    %esp,%ebp
 8048394:	57                   	push   %edi
 8048395:	56                   	push   %esi
 8048396:	53                   	push   %ebx
 8048397:	8b 45 10             	mov    0x10(%ebp),%eax
 804839a:	8b 55 0c             	mov    0xc(%ebp),%edx
 804839d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80483a0:	89 c1                	mov    %eax,%ecx
 80483a2:	89 d6                	mov    %edx,%esi
 80483a4:	89 df                	mov    %ebx,%edi
 80483a6:	fc                   	cld    
 80483a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
 80483a9:	5b                   	pop    %ebx
 80483aa:	5e                   	pop    %esi
 80483ab:	5f                   	pop    %edi
 80483ac:	5d                   	pop    %ebp
 80483ad:	c3                   	ret    

080483ae <memset>:
 80483ae:	55                   	push   %ebp
 80483af:	89 e5                	mov    %esp,%ebp
 80483b1:	57                   	push   %edi
 80483b2:	53                   	push   %ebx
 80483b3:	8b 55 10             	mov    0x10(%ebp),%edx
 80483b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 80483b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80483bc:	89 d1                	mov    %edx,%ecx
 80483be:	89 df                	mov    %ebx,%edi
 80483c0:	fc                   	cld    
 80483c1:	f3 aa                	rep stos %al,%es:(%edi)
 80483c3:	5b                   	pop    %ebx
 80483c4:	5f                   	pop    %edi
 80483c5:	5d                   	pop    %ebp
 80483c6:	c3                   	ret    

080483c7 <strlen>:
 80483c7:	55                   	push   %ebp
 80483c8:	89 e5                	mov    %esp,%ebp
 80483ca:	83 ec 10             	sub    $0x10,%esp
 80483cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 80483d4:	eb 04                	jmp    80483da <strlen+0x13>
 80483d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 80483da:	8b 45 08             	mov    0x8(%ebp),%eax
 80483dd:	8d 50 01             	lea    0x1(%eax),%edx
 80483e0:	89 55 08             	mov    %edx,0x8(%ebp)
 80483e3:	0f b6 00             	movzbl (%eax),%eax
 80483e6:	84 c0                	test   %al,%al
 80483e8:	75 ec                	jne    80483d6 <strlen+0xf>
 80483ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80483ed:	c9                   	leave  
 80483ee:	c3                   	ret    

080483ef <strcpy>:
 80483ef:	55                   	push   %ebp
 80483f0:	89 e5                	mov    %esp,%ebp
 80483f2:	ff 75 0c             	pushl  0xc(%ebp)
 80483f5:	e8 cd ff ff ff       	call   80483c7 <strlen>
 80483fa:	83 c4 04             	add    $0x4,%esp
 80483fd:	83 c0 01             	add    $0x1,%eax
 8048400:	50                   	push   %eax
 8048401:	ff 75 0c             	pushl  0xc(%ebp)
 8048404:	ff 75 08             	pushl  0x8(%ebp)
 8048407:	e8 85 ff ff ff       	call   8048391 <memcpy>
 804840c:	83 c4 0c             	add    $0xc,%esp
 804840f:	c9                   	leave  
 8048410:	c3                   	ret    

08048411 <myprint>:
 8048411:	55                   	push   %ebp
 8048412:	89 e5                	mov    %esp,%ebp
 8048414:	83 ec 08             	sub    $0x8,%esp
 8048417:	83 ec 0c             	sub    $0xc,%esp
 804841a:	6a 2d                	push   $0x2d
 804841c:	e8 9d 10 00 00       	call   80494be <serial_printc>
 8048421:	83 c4 10             	add    $0x10,%esp
 8048424:	83 ec 0c             	sub    $0xc,%esp
 8048427:	6a 32                	push   $0x32
 8048429:	e8 90 10 00 00       	call   80494be <serial_printc>
 804842e:	83 c4 10             	add    $0x10,%esp
 8048431:	83 ec 0c             	sub    $0xc,%esp
 8048434:	6a 31                	push   $0x31
 8048436:	e8 83 10 00 00       	call   80494be <serial_printc>
 804843b:	83 c4 10             	add    $0x10,%esp
 804843e:	83 ec 0c             	sub    $0xc,%esp
 8048441:	6a 34                	push   $0x34
 8048443:	e8 76 10 00 00       	call   80494be <serial_printc>
 8048448:	83 c4 10             	add    $0x10,%esp
 804844b:	83 ec 0c             	sub    $0xc,%esp
 804844e:	6a 37                	push   $0x37
 8048450:	e8 69 10 00 00       	call   80494be <serial_printc>
 8048455:	83 c4 10             	add    $0x10,%esp
 8048458:	83 ec 0c             	sub    $0xc,%esp
 804845b:	6a 34                	push   $0x34
 804845d:	e8 5c 10 00 00       	call   80494be <serial_printc>
 8048462:	83 c4 10             	add    $0x10,%esp
 8048465:	83 ec 0c             	sub    $0xc,%esp
 8048468:	6a 38                	push   $0x38
 804846a:	e8 4f 10 00 00       	call   80494be <serial_printc>
 804846f:	83 c4 10             	add    $0x10,%esp
 8048472:	83 ec 0c             	sub    $0xc,%esp
 8048475:	6a 33                	push   $0x33
 8048477:	e8 42 10 00 00       	call   80494be <serial_printc>
 804847c:	83 c4 10             	add    $0x10,%esp
 804847f:	83 ec 0c             	sub    $0xc,%esp
 8048482:	6a 36                	push   $0x36
 8048484:	e8 35 10 00 00       	call   80494be <serial_printc>
 8048489:	83 c4 10             	add    $0x10,%esp
 804848c:	83 ec 0c             	sub    $0xc,%esp
 804848f:	6a 34                	push   $0x34
 8048491:	e8 28 10 00 00       	call   80494be <serial_printc>
 8048496:	83 c4 10             	add    $0x10,%esp
 8048499:	83 ec 0c             	sub    $0xc,%esp
 804849c:	6a 38                	push   $0x38
 804849e:	e8 1b 10 00 00       	call   80494be <serial_printc>
 80484a3:	83 c4 10             	add    $0x10,%esp
 80484a6:	c9                   	leave  
 80484a7:	c3                   	ret    

080484a8 <vfprintf>:
 80484a8:	55                   	push   %ebp
 80484a9:	89 e5                	mov    %esp,%ebp
 80484ab:	53                   	push   %ebx
 80484ac:	81 ec 94 00 00 00    	sub    $0x94,%esp
 80484b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 80484b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 80484bc:	8d 50 01             	lea    0x1(%eax),%edx
 80484bf:	89 55 0c             	mov    %edx,0xc(%ebp)
 80484c2:	0f b6 00             	movzbl (%eax),%eax
 80484c5:	88 45 eb             	mov    %al,-0x15(%ebp)
 80484c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 80484cf:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
 80484d3:	e9 02 03 00 00       	jmp    80487da <vfprintf+0x332>
 80484d8:	80 7d eb 00          	cmpb   $0x0,-0x15(%ebp)
 80484dc:	75 07                	jne    80484e5 <vfprintf+0x3d>
 80484de:	c7 45 e4 07 00 00 00 	movl   $0x7,-0x1c(%ebp)
 80484e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80484e8:	83 f8 01             	cmp    $0x1,%eax
 80484eb:	74 45                	je     8048532 <vfprintf+0x8a>
 80484ed:	83 f8 07             	cmp    $0x7,%eax
 80484f0:	0f 84 e3 02 00 00    	je     80487d9 <vfprintf+0x331>
 80484f6:	85 c0                	test   %eax,%eax
 80484f8:	74 05                	je     80484ff <vfprintf+0x57>
 80484fa:	e9 db 02 00 00       	jmp    80487da <vfprintf+0x332>
 80484ff:	80 7d eb 25          	cmpb   $0x25,-0x15(%ebp)
 8048503:	75 09                	jne    804850e <vfprintf+0x66>
 8048505:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
 804850c:	eb 10                	jmp    804851e <vfprintf+0x76>
 804850e:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
 8048512:	83 ec 0c             	sub    $0xc,%esp
 8048515:	50                   	push   %eax
 8048516:	8b 45 08             	mov    0x8(%ebp),%eax
 8048519:	ff d0                	call   *%eax
 804851b:	83 c4 10             	add    $0x10,%esp
 804851e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048521:	8d 50 01             	lea    0x1(%eax),%edx
 8048524:	89 55 0c             	mov    %edx,0xc(%ebp)
 8048527:	0f b6 00             	movzbl (%eax),%eax
 804852a:	88 45 eb             	mov    %al,-0x15(%ebp)
 804852d:	e9 a8 02 00 00       	jmp    80487da <vfprintf+0x332>
 8048532:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
 8048536:	83 f8 64             	cmp    $0x64,%eax
 8048539:	74 33                	je     804856e <vfprintf+0xc6>
 804853b:	83 f8 64             	cmp    $0x64,%eax
 804853e:	7f 17                	jg     8048557 <vfprintf+0xaf>
 8048540:	83 f8 25             	cmp    $0x25,%eax
 8048543:	0f 84 66 02 00 00    	je     80487af <vfprintf+0x307>
 8048549:	83 f8 63             	cmp    $0x63,%eax
 804854c:	0f 84 3c 02 00 00    	je     804878e <vfprintf+0x2e6>
 8048552:	e9 66 02 00 00       	jmp    80487bd <vfprintf+0x315>
 8048557:	83 f8 73             	cmp    $0x73,%eax
 804855a:	0f 84 da 01 00 00    	je     804873a <vfprintf+0x292>
 8048560:	83 f8 78             	cmp    $0x78,%eax
 8048563:	0f 84 00 01 00 00    	je     8048669 <vfprintf+0x1c1>
 8048569:	e9 4f 02 00 00       	jmp    80487bd <vfprintf+0x315>
 804856e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048571:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 8048578:	8b 45 10             	mov    0x10(%ebp),%eax
 804857b:	01 d0                	add    %edx,%eax
 804857d:	8b 00                	mov    (%eax),%eax
 804857f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8048582:	81 7d e0 00 00 00 80 	cmpl   $0x80000000,-0x20(%ebp)
 8048589:	75 0a                	jne    8048595 <vfprintf+0xed>
 804858b:	e8 81 fe ff ff       	call   8048411 <myprint>
 8048590:	e9 28 02 00 00       	jmp    80487bd <vfprintf+0x315>
 8048595:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
 8048599:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 804859d:	79 07                	jns    80485a6 <vfprintf+0xfe>
 804859f:	f7 5d e0             	negl   -0x20(%ebp)
 80485a2:	c6 45 df 01          	movb   $0x1,-0x21(%ebp)
 80485a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80485ad:	eb 53                	jmp    8048602 <vfprintf+0x15a>
 80485af:	8b 5d f0             	mov    -0x10(%ebp),%ebx
 80485b2:	8d 43 01             	lea    0x1(%ebx),%eax
 80485b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80485b8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 80485bb:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80485c0:	89 c8                	mov    %ecx,%eax
 80485c2:	f7 ea                	imul   %edx
 80485c4:	c1 fa 02             	sar    $0x2,%edx
 80485c7:	89 c8                	mov    %ecx,%eax
 80485c9:	c1 f8 1f             	sar    $0x1f,%eax
 80485cc:	29 c2                	sub    %eax,%edx
 80485ce:	89 d0                	mov    %edx,%eax
 80485d0:	c1 e0 02             	shl    $0x2,%eax
 80485d3:	01 d0                	add    %edx,%eax
 80485d5:	01 c0                	add    %eax,%eax
 80485d7:	29 c1                	sub    %eax,%ecx
 80485d9:	89 ca                	mov    %ecx,%edx
 80485db:	89 d0                	mov    %edx,%eax
 80485dd:	83 c0 30             	add    $0x30,%eax
 80485e0:	88 84 1d 74 ff ff ff 	mov    %al,-0x8c(%ebp,%ebx,1)
 80485e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 80485ea:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80485ef:	89 c8                	mov    %ecx,%eax
 80485f1:	f7 ea                	imul   %edx
 80485f3:	c1 fa 02             	sar    $0x2,%edx
 80485f6:	89 c8                	mov    %ecx,%eax
 80485f8:	c1 f8 1f             	sar    $0x1f,%eax
 80485fb:	29 c2                	sub    %eax,%edx
 80485fd:	89 d0                	mov    %edx,%eax
 80485ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8048602:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8048605:	83 c0 09             	add    $0x9,%eax
 8048608:	83 f8 12             	cmp    $0x12,%eax
 804860b:	77 a2                	ja     80485af <vfprintf+0x107>
 804860d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8048610:	83 c0 30             	add    $0x30,%eax
 8048613:	89 c1                	mov    %eax,%ecx
 8048615:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
 804861b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804861e:	01 d0                	add    %edx,%eax
 8048620:	88 08                	mov    %cl,(%eax)
 8048622:	80 7d df 00          	cmpb   $0x0,-0x21(%ebp)
 8048626:	74 0d                	je     8048635 <vfprintf+0x18d>
 8048628:	83 ec 0c             	sub    $0xc,%esp
 804862b:	6a 2d                	push   $0x2d
 804862d:	8b 45 08             	mov    0x8(%ebp),%eax
 8048630:	ff d0                	call   *%eax
 8048632:	83 c4 10             	add    $0x10,%esp
 8048635:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048638:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804863b:	eb 21                	jmp    804865e <vfprintf+0x1b6>
 804863d:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
 8048643:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048646:	01 d0                	add    %edx,%eax
 8048648:	0f b6 00             	movzbl (%eax),%eax
 804864b:	0f be c0             	movsbl %al,%eax
 804864e:	83 ec 0c             	sub    $0xc,%esp
 8048651:	50                   	push   %eax
 8048652:	8b 45 08             	mov    0x8(%ebp),%eax
 8048655:	ff d0                	call   *%eax
 8048657:	83 c4 10             	add    $0x10,%esp
 804865a:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 804865e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8048662:	79 d9                	jns    804863d <vfprintf+0x195>
 8048664:	e9 54 01 00 00       	jmp    80487bd <vfprintf+0x315>
 8048669:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804866c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 8048673:	8b 45 10             	mov    0x10(%ebp),%eax
 8048676:	01 d0                	add    %edx,%eax
 8048678:	8b 00                	mov    (%eax),%eax
 804867a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 804867d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8048684:	eb 48                	jmp    80486ce <vfprintf+0x226>
 8048686:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8048689:	83 e0 0f             	and    $0xf,%eax
 804868c:	83 f8 09             	cmp    $0x9,%eax
 804868f:	77 1b                	ja     80486ac <vfprintf+0x204>
 8048691:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048694:	8d 50 01             	lea    0x1(%eax),%edx
 8048697:	89 55 f0             	mov    %edx,-0x10(%ebp)
 804869a:	8b 55 d8             	mov    -0x28(%ebp),%edx
 804869d:	83 e2 0f             	and    $0xf,%edx
 80486a0:	83 c2 30             	add    $0x30,%edx
 80486a3:	88 94 05 74 ff ff ff 	mov    %dl,-0x8c(%ebp,%eax,1)
 80486aa:	eb 19                	jmp    80486c5 <vfprintf+0x21d>
 80486ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80486af:	8d 50 01             	lea    0x1(%eax),%edx
 80486b2:	89 55 f0             	mov    %edx,-0x10(%ebp)
 80486b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
 80486b8:	83 e2 0f             	and    $0xf,%edx
 80486bb:	83 c2 57             	add    $0x57,%edx
 80486be:	88 94 05 74 ff ff ff 	mov    %dl,-0x8c(%ebp,%eax,1)
 80486c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80486c8:	c1 e8 04             	shr    $0x4,%eax
 80486cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
 80486ce:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
 80486d2:	77 b2                	ja     8048686 <vfprintf+0x1de>
 80486d4:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 80486d8:	77 17                	ja     80486f1 <vfprintf+0x249>
 80486da:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80486dd:	83 c0 30             	add    $0x30,%eax
 80486e0:	89 c1                	mov    %eax,%ecx
 80486e2:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
 80486e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80486eb:	01 d0                	add    %edx,%eax
 80486ed:	88 08                	mov    %cl,(%eax)
 80486ef:	eb 15                	jmp    8048706 <vfprintf+0x25e>
 80486f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80486f4:	83 c0 57             	add    $0x57,%eax
 80486f7:	89 c1                	mov    %eax,%ecx
 80486f9:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
 80486ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048702:	01 d0                	add    %edx,%eax
 8048704:	88 08                	mov    %cl,(%eax)
 8048706:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048709:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804870c:	eb 21                	jmp    804872f <vfprintf+0x287>
 804870e:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
 8048714:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048717:	01 d0                	add    %edx,%eax
 8048719:	0f b6 00             	movzbl (%eax),%eax
 804871c:	0f be c0             	movsbl %al,%eax
 804871f:	83 ec 0c             	sub    $0xc,%esp
 8048722:	50                   	push   %eax
 8048723:	8b 45 08             	mov    0x8(%ebp),%eax
 8048726:	ff d0                	call   *%eax
 8048728:	83 c4 10             	add    $0x10,%esp
 804872b:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 804872f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8048733:	79 d9                	jns    804870e <vfprintf+0x266>
 8048735:	e9 83 00 00 00       	jmp    80487bd <vfprintf+0x315>
 804873a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8048741:	eb 2c                	jmp    804876f <vfprintf+0x2c7>
 8048743:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048746:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 804874d:	8b 45 10             	mov    0x10(%ebp),%eax
 8048750:	01 d0                	add    %edx,%eax
 8048752:	8b 10                	mov    (%eax),%edx
 8048754:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048757:	01 d0                	add    %edx,%eax
 8048759:	0f b6 00             	movzbl (%eax),%eax
 804875c:	0f be c0             	movsbl %al,%eax
 804875f:	83 ec 0c             	sub    $0xc,%esp
 8048762:	50                   	push   %eax
 8048763:	8b 45 08             	mov    0x8(%ebp),%eax
 8048766:	ff d0                	call   *%eax
 8048768:	83 c4 10             	add    $0x10,%esp
 804876b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 804876f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048772:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 8048779:	8b 45 10             	mov    0x10(%ebp),%eax
 804877c:	01 d0                	add    %edx,%eax
 804877e:	8b 10                	mov    (%eax),%edx
 8048780:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048783:	01 d0                	add    %edx,%eax
 8048785:	0f b6 00             	movzbl (%eax),%eax
 8048788:	84 c0                	test   %al,%al
 804878a:	75 b7                	jne    8048743 <vfprintf+0x29b>
 804878c:	eb 2f                	jmp    80487bd <vfprintf+0x315>
 804878e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048791:	c1 e0 02             	shl    $0x2,%eax
 8048794:	89 c2                	mov    %eax,%edx
 8048796:	8b 45 10             	mov    0x10(%ebp),%eax
 8048799:	01 d0                	add    %edx,%eax
 804879b:	0f b6 00             	movzbl (%eax),%eax
 804879e:	0f be c0             	movsbl %al,%eax
 80487a1:	83 ec 0c             	sub    $0xc,%esp
 80487a4:	50                   	push   %eax
 80487a5:	8b 45 08             	mov    0x8(%ebp),%eax
 80487a8:	ff d0                	call   *%eax
 80487aa:	83 c4 10             	add    $0x10,%esp
 80487ad:	eb 0e                	jmp    80487bd <vfprintf+0x315>
 80487af:	83 ec 0c             	sub    $0xc,%esp
 80487b2:	6a 25                	push   $0x25
 80487b4:	8b 45 08             	mov    0x8(%ebp),%eax
 80487b7:	ff d0                	call   *%eax
 80487b9:	83 c4 10             	add    $0x10,%esp
 80487bc:	90                   	nop
 80487bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80487c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 80487c4:	8d 50 01             	lea    0x1(%eax),%edx
 80487c7:	89 55 0c             	mov    %edx,0xc(%ebp)
 80487ca:	0f b6 00             	movzbl (%eax),%eax
 80487cd:	88 45 eb             	mov    %al,-0x15(%ebp)
 80487d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 80487d7:	eb 01                	jmp    80487da <vfprintf+0x332>
 80487d9:	90                   	nop
 80487da:	83 7d e4 07          	cmpl   $0x7,-0x1c(%ebp)
 80487de:	0f 85 f4 fc ff ff    	jne    80484d8 <vfprintf+0x30>
 80487e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 80487e7:	c9                   	leave  
 80487e8:	c3                   	ret    

080487e9 <printk>:
 80487e9:	55                   	push   %ebp
 80487ea:	89 e5                	mov    %esp,%ebp
 80487ec:	83 ec 18             	sub    $0x18,%esp
 80487ef:	8d 45 0c             	lea    0xc(%ebp),%eax
 80487f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80487f5:	8b 45 08             	mov    0x8(%ebp),%eax
 80487f8:	83 ec 04             	sub    $0x4,%esp
 80487fb:	ff 75 f4             	pushl  -0xc(%ebp)
 80487fe:	50                   	push   %eax
 80487ff:	68 be 94 04 08       	push   $0x80494be
 8048804:	e8 9f fc ff ff       	call   80484a8 <vfprintf>
 8048809:	83 c4 10             	add    $0x10,%esp
 804880c:	c9                   	leave  
 804880d:	c3                   	ret    

0804880e <wait_for_interrupt>:
 804880e:	55                   	push   %ebp
 804880f:	89 e5                	mov    %esp,%ebp
 8048811:	f4                   	hlt    
 8048812:	5d                   	pop    %ebp
 8048813:	c3                   	ret    

08048814 <disable_interrupt>:
 8048814:	55                   	push   %ebp
 8048815:	89 e5                	mov    %esp,%ebp
 8048817:	fa                   	cli    
 8048818:	5d                   	pop    %ebp
 8048819:	c3                   	ret    

0804881a <append>:
 804881a:	55                   	push   %ebp
 804881b:	89 e5                	mov    %esp,%ebp
 804881d:	eb 1b                	jmp    804883a <append+0x20>
 804881f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048822:	8b 00                	mov    (%eax),%eax
 8048824:	8d 48 01             	lea    0x1(%eax),%ecx
 8048827:	8b 55 08             	mov    0x8(%ebp),%edx
 804882a:	89 0a                	mov    %ecx,(%edx)
 804882c:	8b 55 0c             	mov    0xc(%ebp),%edx
 804882f:	8d 4a 01             	lea    0x1(%edx),%ecx
 8048832:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 8048835:	0f b6 12             	movzbl (%edx),%edx
 8048838:	88 10                	mov    %dl,(%eax)
 804883a:	8b 45 0c             	mov    0xc(%ebp),%eax
 804883d:	0f b6 00             	movzbl (%eax),%eax
 8048840:	84 c0                	test   %al,%al
 8048842:	75 db                	jne    804881f <append+0x5>
 8048844:	5d                   	pop    %ebp
 8048845:	c3                   	ret    

08048846 <blue_screen>:
 8048846:	55                   	push   %ebp
 8048847:	89 e5                	mov    %esp,%ebp
 8048849:	83 ec 18             	sub    $0x18,%esp
 804884c:	c7 45 f4 d2 b2 04 08 	movl   $0x804b2d2,-0xc(%ebp)
 8048853:	ff 75 08             	pushl  0x8(%ebp)
 8048856:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8048859:	50                   	push   %eax
 804885a:	e8 bb ff ff ff       	call   804881a <append>
 804885f:	83 c4 08             	add    $0x8,%esp
 8048862:	68 02 99 04 08       	push   $0x8049902
 8048867:	8d 45 f4             	lea    -0xc(%ebp),%eax
 804886a:	50                   	push   %eax
 804886b:	e8 aa ff ff ff       	call   804881a <append>
 8048870:	83 c4 08             	add    $0x8,%esp
 8048873:	83 ec 0c             	sub    $0xc,%esp
 8048876:	ff 75 0c             	pushl  0xc(%ebp)
 8048879:	e8 ad fa ff ff       	call   804832b <itoa>
 804887e:	83 c4 10             	add    $0x10,%esp
 8048881:	83 ec 08             	sub    $0x8,%esp
 8048884:	50                   	push   %eax
 8048885:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8048888:	50                   	push   %eax
 8048889:	e8 8c ff ff ff       	call   804881a <append>
 804888e:	83 c4 10             	add    $0x10,%esp
 8048891:	e8 3f 0d 00 00       	call   80495d5 <prepare_buffer>
 8048896:	a1 00 b8 04 08       	mov    0x804b800,%eax
 804889b:	83 ec 04             	sub    $0x4,%esp
 804889e:	68 00 fa 00 00       	push   $0xfa00
 80488a3:	6a 01                	push   $0x1
 80488a5:	50                   	push   %eax
 80488a6:	e8 03 fb ff ff       	call   80483ae <memset>
 80488ab:	83 c4 10             	add    $0x10,%esp
 80488ae:	6a 0f                	push   $0xf
 80488b0:	6a 00                	push   $0x0
 80488b2:	6a 00                	push   $0x0
 80488b4:	68 c0 b2 04 08       	push   $0x804b2c0
 80488b9:	e8 79 0e 00 00       	call   8049737 <draw_string>
 80488be:	83 c4 10             	add    $0x10,%esp
 80488c1:	e8 53 0d 00 00       	call   8049619 <display_buffer>
 80488c6:	c9                   	leave  
 80488c7:	c3                   	ret    

080488c8 <abort>:
 80488c8:	55                   	push   %ebp
 80488c9:	89 e5                	mov    %esp,%ebp
 80488cb:	83 ec 08             	sub    $0x8,%esp
 80488ce:	e8 41 ff ff ff       	call   8048814 <disable_interrupt>
 80488d3:	83 ec 08             	sub    $0x8,%esp
 80488d6:	ff 75 0c             	pushl  0xc(%ebp)
 80488d9:	ff 75 08             	pushl  0x8(%ebp)
 80488dc:	e8 65 ff ff ff       	call   8048846 <blue_screen>
 80488e1:	83 c4 10             	add    $0x10,%esp
 80488e4:	e8 25 ff ff ff       	call   804880e <wait_for_interrupt>
 80488e9:	eb f9                	jmp    80488e4 <abort+0x1c>

080488eb <redraw_screen>:
 80488eb:	55                   	push   %ebp
 80488ec:	89 e5                	mov    %esp,%ebp
 80488ee:	83 ec 28             	sub    $0x28,%esp
 80488f1:	e8 df 0c 00 00       	call   80495d5 <prepare_buffer>
 80488f6:	e8 ce 06 00 00       	call   8048fc9 <characters>
 80488fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80488fe:	eb 7d                	jmp    804897d <redraw_screen+0x92>
 8048900:	c6 05 70 bb 04 08 78 	movb   $0x78,0x804bb70
 8048907:	c6 05 71 bb 04 08 00 	movb   $0x0,0x804bb71
 804890e:	e8 f3 f9 ff ff       	call   8048306 <rand>
 8048913:	89 c1                	mov    %eax,%ecx
 8048915:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 804891a:	89 c8                	mov    %ecx,%eax
 804891c:	f7 ea                	imul   %edx
 804891e:	c1 fa 05             	sar    $0x5,%edx
 8048921:	89 c8                	mov    %ecx,%eax
 8048923:	c1 f8 1f             	sar    $0x1f,%eax
 8048926:	29 c2                	sub    %eax,%edx
 8048928:	89 d0                	mov    %edx,%eax
 804892a:	6b c0 64             	imul   $0x64,%eax,%eax
 804892d:	29 c1                	sub    %eax,%ecx
 804892f:	89 c8                	mov    %ecx,%eax
 8048931:	8d 50 32             	lea    0x32(%eax),%edx
 8048934:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048937:	d9 40 04             	flds   0x4(%eax)
 804893a:	d9 7d e6             	fnstcw -0x1a(%ebp)
 804893d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
 8048941:	b4 0c                	mov    $0xc,%ah
 8048943:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
 8048947:	d9 6d e4             	fldcw  -0x1c(%ebp)
 804894a:	db 5d e0             	fistpl -0x20(%ebp)
 804894d:	d9 6d e6             	fldcw  -0x1a(%ebp)
 8048950:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 8048953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048956:	d9 00                	flds   (%eax)
 8048958:	d9 6d e4             	fldcw  -0x1c(%ebp)
 804895b:	db 5d e0             	fistpl -0x20(%ebp)
 804895e:	d9 6d e6             	fldcw  -0x1a(%ebp)
 8048961:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8048964:	52                   	push   %edx
 8048965:	51                   	push   %ecx
 8048966:	50                   	push   %eax
 8048967:	68 70 bb 04 08       	push   $0x804bb70
 804896c:	e8 c6 0d 00 00       	call   8049737 <draw_string>
 8048971:	83 c4 10             	add    $0x10,%esp
 8048974:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048977:	8b 40 14             	mov    0x14(%eax),%eax
 804897a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804897d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8048981:	0f 85 79 ff ff ff    	jne    8048900 <redraw_screen+0x15>
 8048987:	e8 47 06 00 00       	call   8048fd3 <buls>
 804898c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804898f:	eb 58                	jmp    80489e9 <redraw_screen+0xfe>
 8048991:	c6 05 72 bb 04 08 6f 	movb   $0x6f,0x804bb72
 8048998:	c6 05 73 bb 04 08 00 	movb   $0x0,0x804bb73
 804899f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80489a2:	d9 40 04             	flds   0x4(%eax)
 80489a5:	d9 7d e6             	fnstcw -0x1a(%ebp)
 80489a8:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
 80489ac:	b4 0c                	mov    $0xc,%ah
 80489ae:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
 80489b2:	d9 6d e4             	fldcw  -0x1c(%ebp)
 80489b5:	db 5d e0             	fistpl -0x20(%ebp)
 80489b8:	d9 6d e6             	fldcw  -0x1a(%ebp)
 80489bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
 80489be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80489c1:	d9 00                	flds   (%eax)
 80489c3:	d9 6d e4             	fldcw  -0x1c(%ebp)
 80489c6:	db 5d e0             	fistpl -0x20(%ebp)
 80489c9:	d9 6d e6             	fldcw  -0x1a(%ebp)
 80489cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80489cf:	6a 30                	push   $0x30
 80489d1:	52                   	push   %edx
 80489d2:	50                   	push   %eax
 80489d3:	68 72 bb 04 08       	push   $0x804bb72
 80489d8:	e8 5a 0d 00 00       	call   8049737 <draw_string>
 80489dd:	83 c4 10             	add    $0x10,%esp
 80489e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80489e3:	8b 40 10             	mov    0x10(%eax),%eax
 80489e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80489e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 80489ed:	75 a2                	jne    8048991 <redraw_screen+0xa6>
 80489ef:	c6 05 74 bb 04 08 6f 	movb   $0x6f,0x804bb74
 80489f6:	c6 05 75 bb 04 08 00 	movb   $0x0,0x804bb75
 80489fd:	e8 6f 05 00 00       	call   8048f71 <get_y>
 8048a02:	6a 0a                	push   $0xa
 8048a04:	50                   	push   %eax
 8048a05:	68 b4 00 00 00       	push   $0xb4
 8048a0a:	68 74 bb 04 08       	push   $0x804bb74
 8048a0f:	e8 23 0d 00 00       	call   8049737 <draw_string>
 8048a14:	83 c4 10             	add    $0x10,%esp
 8048a17:	e8 99 05 00 00       	call   8048fb5 <get_hit>
 8048a1c:	83 ec 0c             	sub    $0xc,%esp
 8048a1f:	50                   	push   %eax
 8048a20:	e8 06 f9 ff ff       	call   804832b <itoa>
 8048a25:	83 c4 10             	add    $0x10,%esp
 8048a28:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8048a2b:	83 ec 0c             	sub    $0xc,%esp
 8048a2e:	ff 75 ec             	pushl  -0x14(%ebp)
 8048a31:	e8 91 f9 ff ff       	call   80483c7 <strlen>
 8048a36:	83 c4 10             	add    $0x10,%esp
 8048a39:	89 c2                	mov    %eax,%edx
 8048a3b:	b8 00 00 00 00       	mov    $0x0,%eax
 8048a40:	29 d0                	sub    %edx,%eax
 8048a42:	c1 e0 03             	shl    $0x3,%eax
 8048a45:	05 40 01 00 00       	add    $0x140,%eax
 8048a4a:	6a 0a                	push   $0xa
 8048a4c:	50                   	push   %eax
 8048a4d:	6a 00                	push   $0x0
 8048a4f:	ff 75 ec             	pushl  -0x14(%ebp)
 8048a52:	e8 e0 0c 00 00       	call   8049737 <draw_string>
 8048a57:	83 c4 10             	add    $0x10,%esp
 8048a5a:	e8 60 05 00 00       	call   8048fbf <get_miss>
 8048a5f:	83 ec 0c             	sub    $0xc,%esp
 8048a62:	50                   	push   %eax
 8048a63:	e8 c3 f8 ff ff       	call   804832b <itoa>
 8048a68:	83 c4 10             	add    $0x10,%esp
 8048a6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8048a6e:	83 ec 0c             	sub    $0xc,%esp
 8048a71:	ff 75 e8             	pushl  -0x18(%ebp)
 8048a74:	e8 4e f9 ff ff       	call   80483c7 <strlen>
 8048a79:	83 c4 10             	add    $0x10,%esp
 8048a7c:	89 c2                	mov    %eax,%edx
 8048a7e:	b8 00 00 00 00       	mov    $0x0,%eax
 8048a83:	29 d0                	sub    %edx,%eax
 8048a85:	c1 e0 03             	shl    $0x3,%eax
 8048a88:	05 40 01 00 00       	add    $0x140,%eax
 8048a8d:	6a 0c                	push   $0xc
 8048a8f:	50                   	push   %eax
 8048a90:	68 b8 00 00 00       	push   $0xb8
 8048a95:	ff 75 e8             	pushl  -0x18(%ebp)
 8048a98:	e8 9a 0c 00 00       	call   8049737 <draw_string>
 8048a9d:	83 c4 10             	add    $0x10,%esp
 8048aa0:	e8 40 f6 ff ff       	call   80480e5 <get_fps>
 8048aa5:	83 ec 0c             	sub    $0xc,%esp
 8048aa8:	50                   	push   %eax
 8048aa9:	e8 7d f8 ff ff       	call   804832b <itoa>
 8048aae:	83 c4 10             	add    $0x10,%esp
 8048ab1:	6a 0e                	push   $0xe
 8048ab3:	6a 00                	push   $0x0
 8048ab5:	6a 00                	push   $0x0
 8048ab7:	50                   	push   %eax
 8048ab8:	e8 7a 0c 00 00       	call   8049737 <draw_string>
 8048abd:	83 c4 10             	add    $0x10,%esp
 8048ac0:	e8 20 f6 ff ff       	call   80480e5 <get_fps>
 8048ac5:	83 ec 0c             	sub    $0xc,%esp
 8048ac8:	50                   	push   %eax
 8048ac9:	e8 5d f8 ff ff       	call   804832b <itoa>
 8048ace:	83 c4 10             	add    $0x10,%esp
 8048ad1:	83 ec 0c             	sub    $0xc,%esp
 8048ad4:	50                   	push   %eax
 8048ad5:	e8 ed f8 ff ff       	call   80483c7 <strlen>
 8048ada:	83 c4 10             	add    $0x10,%esp
 8048add:	c1 e0 03             	shl    $0x3,%eax
 8048ae0:	6a 0e                	push   $0xe
 8048ae2:	50                   	push   %eax
 8048ae3:	6a 00                	push   $0x0
 8048ae5:	68 04 99 04 08       	push   $0x8049904
 8048aea:	e8 48 0c 00 00       	call   8049737 <draw_string>
 8048aef:	83 c4 10             	add    $0x10,%esp
 8048af2:	e8 22 0b 00 00       	call   8049619 <display_buffer>
 8048af7:	c9                   	leave  
 8048af8:	c3                   	ret    

08048af9 <press_key>:
 8048af9:	55                   	push   %ebp
 8048afa:	89 e5                	mov    %esp,%ebp
 8048afc:	83 ec 10             	sub    $0x10,%esp
 8048aff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048b06:	eb 1e                	jmp    8048b26 <press_key+0x2d>
 8048b08:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048b0b:	8b 04 85 c0 b3 04 08 	mov    0x804b3c0(,%eax,4),%eax
 8048b12:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048b15:	75 0b                	jne    8048b22 <press_key+0x29>
 8048b17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048b1a:	05 00 67 0d 08       	add    $0x80d6700,%eax
 8048b1f:	c6 00 01             	movb   $0x1,(%eax)
 8048b22:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8048b26:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
 8048b2a:	7e dc                	jle    8048b08 <press_key+0xf>
 8048b2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048b33:	eb 20                	jmp    8048b55 <press_key+0x5c>
 8048b35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048b38:	8b 04 85 c0 b3 04 08 	mov    0x804b3c0(,%eax,4),%eax
 8048b3f:	0c 80                	or     $0x80,%al
 8048b41:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048b44:	75 0b                	jne    8048b51 <press_key+0x58>
 8048b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048b49:	05 00 67 0d 08       	add    $0x80d6700,%eax
 8048b4e:	c6 00 00             	movb   $0x0,(%eax)
 8048b51:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8048b55:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
 8048b59:	7e da                	jle    8048b35 <press_key+0x3c>
 8048b5b:	c9                   	leave  
 8048b5c:	c3                   	ret    

08048b5d <release_key>:
 8048b5d:	55                   	push   %ebp
 8048b5e:	89 e5                	mov    %esp,%ebp
 8048b60:	83 ec 08             	sub    $0x8,%esp
 8048b63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048b67:	78 06                	js     8048b6f <release_key+0x12>
 8048b69:	83 7d 08 19          	cmpl   $0x19,0x8(%ebp)
 8048b6d:	7e 12                	jle    8048b81 <release_key+0x24>
 8048b6f:	83 ec 08             	sub    $0x8,%esp
 8048b72:	6a 21                	push   $0x21
 8048b74:	68 08 99 04 08       	push   $0x8049908
 8048b79:	e8 4a fd ff ff       	call   80488c8 <abort>
 8048b7e:	83 c4 10             	add    $0x10,%esp
 8048b81:	8b 45 08             	mov    0x8(%ebp),%eax
 8048b84:	05 00 67 0d 08       	add    $0x80d6700,%eax
 8048b89:	c6 00 00             	movb   $0x0,(%eax)
 8048b8c:	c9                   	leave  
 8048b8d:	c3                   	ret    

08048b8e <query_key>:
 8048b8e:	55                   	push   %ebp
 8048b8f:	89 e5                	mov    %esp,%ebp
 8048b91:	83 ec 08             	sub    $0x8,%esp
 8048b94:	8b 45 08             	mov    0x8(%ebp),%eax
 8048b97:	85 c0                	test   %eax,%eax
 8048b99:	78 08                	js     8048ba3 <query_key+0x15>
 8048b9b:	8b 45 08             	mov    0x8(%ebp),%eax
 8048b9e:	83 f8 19             	cmp    $0x19,%eax
 8048ba1:	7e 12                	jle    8048bb5 <query_key+0x27>
 8048ba3:	83 ec 08             	sub    $0x8,%esp
 8048ba6:	6a 27                	push   $0x27
 8048ba8:	68 08 99 04 08       	push   $0x8049908
 8048bad:	e8 16 fd ff ff       	call   80488c8 <abort>
 8048bb2:	83 c4 10             	add    $0x10,%esp
 8048bb5:	8b 45 08             	mov    0x8(%ebp),%eax
 8048bb8:	0f b6 80 00 67 0d 08 	movzbl 0x80d6700(%eax),%eax
 8048bbf:	c9                   	leave  
 8048bc0:	c3                   	ret    

08048bc1 <last_key_code>:
 8048bc1:	55                   	push   %ebp
 8048bc2:	89 e5                	mov    %esp,%ebp
 8048bc4:	a1 78 bb 04 08       	mov    0x804bb78,%eax
 8048bc9:	5d                   	pop    %ebp
 8048bca:	c3                   	ret    

08048bcb <keyboard_event>:
 8048bcb:	55                   	push   %ebp
 8048bcc:	89 e5                	mov    %esp,%ebp
 8048bce:	8b 45 08             	mov    0x8(%ebp),%eax
 8048bd1:	a3 78 bb 04 08       	mov    %eax,0x804bb78
 8048bd6:	ff 75 08             	pushl  0x8(%ebp)
 8048bd9:	e8 1b ff ff ff       	call   8048af9 <press_key>
 8048bde:	83 c4 04             	add    $0x4,%esp
 8048be1:	c9                   	leave  
 8048be2:	c3                   	ret    

08048be3 <enable_interrupt>:
 8048be3:	55                   	push   %ebp
 8048be4:	89 e5                	mov    %esp,%ebp
 8048be6:	fb                   	sti    
 8048be7:	5d                   	pop    %ebp
 8048be8:	c3                   	ret    

08048be9 <disable_interrupt>:
 8048be9:	55                   	push   %ebp
 8048bea:	89 e5                	mov    %esp,%ebp
 8048bec:	fa                   	cli    
 8048bed:	5d                   	pop    %ebp
 8048bee:	c3                   	ret    

08048bef <fly_new>:
 8048bef:	55                   	push   %ebp
 8048bf0:	89 e5                	mov    %esp,%ebp
 8048bf2:	83 ec 18             	sub    $0x18,%esp
 8048bf5:	a1 58 65 08 08       	mov    0x8086558,%eax
 8048bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048bfd:	c7 45 ec c0 bb 04 08 	movl   $0x804bbc0,-0x14(%ebp)
 8048c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8048c08:	75 47                	jne    8048c51 <fly_new+0x62>
 8048c0a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 8048c11:	eb 2f                	jmp    8048c42 <fly_new+0x53>
 8048c13:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8048c16:	89 d0                	mov    %edx,%eax
 8048c18:	01 c0                	add    %eax,%eax
 8048c1a:	01 d0                	add    %edx,%eax
 8048c1c:	c1 e0 03             	shl    $0x3,%eax
 8048c1f:	8d 50 e8             	lea    -0x18(%eax),%edx
 8048c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048c25:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048c28:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8048c2b:	89 d0                	mov    %edx,%eax
 8048c2d:	01 c0                	add    %eax,%eax
 8048c2f:	01 d0                	add    %edx,%eax
 8048c31:	c1 e0 03             	shl    $0x3,%eax
 8048c34:	89 c2                	mov    %eax,%edx
 8048c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048c39:	01 d0                	add    %edx,%eax
 8048c3b:	89 41 14             	mov    %eax,0x14(%ecx)
 8048c3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8048c42:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
 8048c49:	7e c8                	jle    8048c13 <fly_new+0x24>
 8048c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c54:	8b 40 14             	mov    0x14(%eax),%eax
 8048c57:	85 c0                	test   %eax,%eax
 8048c59:	75 12                	jne    8048c6d <fly_new+0x7e>
 8048c5b:	83 ec 08             	sub    $0x8,%esp
 8048c5e:	6a 08                	push   $0x8
 8048c60:	68 20 99 04 08       	push   $0x8049920
 8048c65:	e8 5e fc ff ff       	call   80488c8 <abort>
 8048c6a:	83 c4 10             	add    $0x10,%esp
 8048c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c70:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8048c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c76:	8b 40 14             	mov    0x14(%eax),%eax
 8048c79:	a3 58 65 08 08       	mov    %eax,0x8086558
 8048c7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048c81:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
 8048c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048c8b:	8b 50 14             	mov    0x14(%eax),%edx
 8048c8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048c91:	89 50 10             	mov    %edx,0x10(%eax)
 8048c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048c97:	c9                   	leave  
 8048c98:	c3                   	ret    

08048c99 <fly_prev>:
 8048c99:	55                   	push   %ebp
 8048c9a:	89 e5                	mov    %esp,%ebp
 8048c9c:	83 ec 08             	sub    $0x8,%esp
 8048c9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048ca3:	75 12                	jne    8048cb7 <fly_prev+0x1e>
 8048ca5:	83 ec 08             	sub    $0x8,%esp
 8048ca8:	6a 08                	push   $0x8
 8048caa:	68 20 99 04 08       	push   $0x8049920
 8048caf:	e8 14 fc ff ff       	call   80488c8 <abort>
 8048cb4:	83 c4 10             	add    $0x10,%esp
 8048cb7:	8b 45 08             	mov    0x8(%ebp),%eax
 8048cba:	8b 40 10             	mov    0x10(%eax),%eax
 8048cbd:	c9                   	leave  
 8048cbe:	c3                   	ret    

08048cbf <fly_next>:
 8048cbf:	55                   	push   %ebp
 8048cc0:	89 e5                	mov    %esp,%ebp
 8048cc2:	83 ec 08             	sub    $0x8,%esp
 8048cc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048cc9:	75 12                	jne    8048cdd <fly_next+0x1e>
 8048ccb:	83 ec 08             	sub    $0x8,%esp
 8048cce:	6a 08                	push   $0x8
 8048cd0:	68 20 99 04 08       	push   $0x8049920
 8048cd5:	e8 ee fb ff ff       	call   80488c8 <abort>
 8048cda:	83 c4 10             	add    $0x10,%esp
 8048cdd:	8b 45 08             	mov    0x8(%ebp),%eax
 8048ce0:	8b 40 14             	mov    0x14(%eax),%eax
 8048ce3:	c9                   	leave  
 8048ce4:	c3                   	ret    

08048ce5 <fly_insert>:
 8048ce5:	55                   	push   %ebp
 8048ce6:	89 e5                	mov    %esp,%ebp
 8048ce8:	83 ec 08             	sub    $0x8,%esp
 8048ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048cef:	75 18                	jne    8048d09 <fly_insert+0x24>
 8048cf1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8048cf5:	75 12                	jne    8048d09 <fly_insert+0x24>
 8048cf7:	83 ec 08             	sub    $0x8,%esp
 8048cfa:	6a 08                	push   $0x8
 8048cfc:	68 20 99 04 08       	push   $0x8049920
 8048d01:	e8 c2 fb ff ff       	call   80488c8 <abort>
 8048d06:	83 c4 10             	add    $0x10,%esp
 8048d09:	8b 45 10             	mov    0x10(%ebp),%eax
 8048d0c:	8b 55 08             	mov    0x8(%ebp),%edx
 8048d0f:	89 50 10             	mov    %edx,0x10(%eax)
 8048d12:	8b 45 10             	mov    0x10(%ebp),%eax
 8048d15:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048d18:	89 50 14             	mov    %edx,0x14(%eax)
 8048d1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048d1f:	74 09                	je     8048d2a <fly_insert+0x45>
 8048d21:	8b 45 08             	mov    0x8(%ebp),%eax
 8048d24:	8b 55 10             	mov    0x10(%ebp),%edx
 8048d27:	89 50 14             	mov    %edx,0x14(%eax)
 8048d2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8048d2e:	74 09                	je     8048d39 <fly_insert+0x54>
 8048d30:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048d33:	8b 55 10             	mov    0x10(%ebp),%edx
 8048d36:	89 50 10             	mov    %edx,0x10(%eax)
 8048d39:	c9                   	leave  
 8048d3a:	c3                   	ret    

08048d3b <fly_remove>:
 8048d3b:	55                   	push   %ebp
 8048d3c:	89 e5                	mov    %esp,%ebp
 8048d3e:	83 ec 18             	sub    $0x18,%esp
 8048d41:	8b 45 08             	mov    0x8(%ebp),%eax
 8048d44:	8b 40 10             	mov    0x10(%eax),%eax
 8048d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048d4a:	8b 45 08             	mov    0x8(%ebp),%eax
 8048d4d:	8b 40 14             	mov    0x14(%eax),%eax
 8048d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048d53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048d57:	75 12                	jne    8048d6b <fly_remove+0x30>
 8048d59:	83 ec 08             	sub    $0x8,%esp
 8048d5c:	6a 08                	push   $0x8
 8048d5e:	68 20 99 04 08       	push   $0x8049920
 8048d63:	e8 60 fb ff ff       	call   80488c8 <abort>
 8048d68:	83 c4 10             	add    $0x10,%esp
 8048d6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8048d6f:	74 09                	je     8048d7a <fly_remove+0x3f>
 8048d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d74:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8048d77:	89 50 14             	mov    %edx,0x14(%eax)
 8048d7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8048d7e:	74 09                	je     8048d89 <fly_remove+0x4e>
 8048d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048d86:	89 50 10             	mov    %edx,0x10(%eax)
 8048d89:	c9                   	leave  
 8048d8a:	c3                   	ret    

08048d8b <fly_free>:
 8048d8b:	55                   	push   %ebp
 8048d8c:	89 e5                	mov    %esp,%ebp
 8048d8e:	8b 15 58 65 08 08    	mov    0x8086558,%edx
 8048d94:	8b 45 08             	mov    0x8(%ebp),%eax
 8048d97:	89 50 14             	mov    %edx,0x14(%eax)
 8048d9a:	8b 45 08             	mov    0x8(%ebp),%eax
 8048d9d:	a3 58 65 08 08       	mov    %eax,0x8086558
 8048da2:	5d                   	pop    %ebp
 8048da3:	c3                   	ret    

08048da4 <bul_new>:
 8048da4:	55                   	push   %ebp
 8048da5:	89 e5                	mov    %esp,%ebp
 8048da7:	83 ec 18             	sub    $0x18,%esp
 8048daa:	a1 d4 72 0b 08       	mov    0x80b72d4,%eax
 8048daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048db2:	c7 45 ec 80 65 08 08 	movl   $0x8086580,-0x14(%ebp)
 8048db9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8048dbd:	75 49                	jne    8048e08 <bul_new+0x64>
 8048dbf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 8048dc6:	eb 31                	jmp    8048df9 <bul_new+0x55>
 8048dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8048dcb:	89 d0                	mov    %edx,%eax
 8048dcd:	c1 e0 02             	shl    $0x2,%eax
 8048dd0:	01 d0                	add    %edx,%eax
 8048dd2:	c1 e0 02             	shl    $0x2,%eax
 8048dd5:	8d 50 ec             	lea    -0x14(%eax),%edx
 8048dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048ddb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048dde:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8048de1:	89 d0                	mov    %edx,%eax
 8048de3:	c1 e0 02             	shl    $0x2,%eax
 8048de6:	01 d0                	add    %edx,%eax
 8048de8:	c1 e0 02             	shl    $0x2,%eax
 8048deb:	89 c2                	mov    %eax,%edx
 8048ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048df0:	01 d0                	add    %edx,%eax
 8048df2:	89 41 10             	mov    %eax,0x10(%ecx)
 8048df5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8048df9:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
 8048e00:	7e c6                	jle    8048dc8 <bul_new+0x24>
 8048e02:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8048e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e0b:	8b 40 10             	mov    0x10(%eax),%eax
 8048e0e:	85 c0                	test   %eax,%eax
 8048e10:	75 12                	jne    8048e24 <bul_new+0x80>
 8048e12:	83 ec 08             	sub    $0x8,%esp
 8048e15:	6a 09                	push   $0x9
 8048e17:	68 20 99 04 08       	push   $0x8049920
 8048e1c:	e8 a7 fa ff ff       	call   80488c8 <abort>
 8048e21:	83 c4 10             	add    $0x10,%esp
 8048e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e27:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8048e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e2d:	8b 40 10             	mov    0x10(%eax),%eax
 8048e30:	a3 d4 72 0b 08       	mov    %eax,0x80b72d4
 8048e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048e38:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
 8048e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048e42:	8b 50 10             	mov    0x10(%eax),%edx
 8048e45:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048e48:	89 50 0c             	mov    %edx,0xc(%eax)
 8048e4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048e4e:	c9                   	leave  
 8048e4f:	c3                   	ret    

08048e50 <bul_prev>:
 8048e50:	55                   	push   %ebp
 8048e51:	89 e5                	mov    %esp,%ebp
 8048e53:	83 ec 08             	sub    $0x8,%esp
 8048e56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048e5a:	75 12                	jne    8048e6e <bul_prev+0x1e>
 8048e5c:	83 ec 08             	sub    $0x8,%esp
 8048e5f:	6a 09                	push   $0x9
 8048e61:	68 20 99 04 08       	push   $0x8049920
 8048e66:	e8 5d fa ff ff       	call   80488c8 <abort>
 8048e6b:	83 c4 10             	add    $0x10,%esp
 8048e6e:	8b 45 08             	mov    0x8(%ebp),%eax
 8048e71:	8b 40 0c             	mov    0xc(%eax),%eax
 8048e74:	c9                   	leave  
 8048e75:	c3                   	ret    

08048e76 <bul_next>:
 8048e76:	55                   	push   %ebp
 8048e77:	89 e5                	mov    %esp,%ebp
 8048e79:	83 ec 08             	sub    $0x8,%esp
 8048e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048e80:	75 12                	jne    8048e94 <bul_next+0x1e>
 8048e82:	83 ec 08             	sub    $0x8,%esp
 8048e85:	6a 09                	push   $0x9
 8048e87:	68 20 99 04 08       	push   $0x8049920
 8048e8c:	e8 37 fa ff ff       	call   80488c8 <abort>
 8048e91:	83 c4 10             	add    $0x10,%esp
 8048e94:	8b 45 08             	mov    0x8(%ebp),%eax
 8048e97:	8b 40 10             	mov    0x10(%eax),%eax
 8048e9a:	c9                   	leave  
 8048e9b:	c3                   	ret    

08048e9c <bul_insert>:
 8048e9c:	55                   	push   %ebp
 8048e9d:	89 e5                	mov    %esp,%ebp
 8048e9f:	83 ec 08             	sub    $0x8,%esp
 8048ea2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048ea6:	75 18                	jne    8048ec0 <bul_insert+0x24>
 8048ea8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8048eac:	75 12                	jne    8048ec0 <bul_insert+0x24>
 8048eae:	83 ec 08             	sub    $0x8,%esp
 8048eb1:	6a 09                	push   $0x9
 8048eb3:	68 20 99 04 08       	push   $0x8049920
 8048eb8:	e8 0b fa ff ff       	call   80488c8 <abort>
 8048ebd:	83 c4 10             	add    $0x10,%esp
 8048ec0:	8b 45 10             	mov    0x10(%ebp),%eax
 8048ec3:	8b 55 08             	mov    0x8(%ebp),%edx
 8048ec6:	89 50 0c             	mov    %edx,0xc(%eax)
 8048ec9:	8b 45 10             	mov    0x10(%ebp),%eax
 8048ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048ecf:	89 50 10             	mov    %edx,0x10(%eax)
 8048ed2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048ed6:	74 09                	je     8048ee1 <bul_insert+0x45>
 8048ed8:	8b 45 08             	mov    0x8(%ebp),%eax
 8048edb:	8b 55 10             	mov    0x10(%ebp),%edx
 8048ede:	89 50 10             	mov    %edx,0x10(%eax)
 8048ee1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8048ee5:	74 09                	je     8048ef0 <bul_insert+0x54>
 8048ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048eea:	8b 55 10             	mov    0x10(%ebp),%edx
 8048eed:	89 50 0c             	mov    %edx,0xc(%eax)
 8048ef0:	c9                   	leave  
 8048ef1:	c3                   	ret    

08048ef2 <bul_remove>:
 8048ef2:	55                   	push   %ebp
 8048ef3:	89 e5                	mov    %esp,%ebp
 8048ef5:	83 ec 18             	sub    $0x18,%esp
 8048ef8:	8b 45 08             	mov    0x8(%ebp),%eax
 8048efb:	8b 40 0c             	mov    0xc(%eax),%eax
 8048efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048f01:	8b 45 08             	mov    0x8(%ebp),%eax
 8048f04:	8b 40 10             	mov    0x10(%eax),%eax
 8048f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048f0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048f0e:	75 12                	jne    8048f22 <bul_remove+0x30>
 8048f10:	83 ec 08             	sub    $0x8,%esp
 8048f13:	6a 09                	push   $0x9
 8048f15:	68 20 99 04 08       	push   $0x8049920
 8048f1a:	e8 a9 f9 ff ff       	call   80488c8 <abort>
 8048f1f:	83 c4 10             	add    $0x10,%esp
 8048f22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8048f26:	74 09                	je     8048f31 <bul_remove+0x3f>
 8048f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8048f2e:	89 50 10             	mov    %edx,0x10(%eax)
 8048f31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8048f35:	74 09                	je     8048f40 <bul_remove+0x4e>
 8048f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048f3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048f3d:	89 50 0c             	mov    %edx,0xc(%eax)
 8048f40:	c9                   	leave  
 8048f41:	c3                   	ret    

08048f42 <bul_free>:
 8048f42:	55                   	push   %ebp
 8048f43:	89 e5                	mov    %esp,%ebp
 8048f45:	8b 15 d4 72 0b 08    	mov    0x80b72d4,%edx
 8048f4b:	8b 45 08             	mov    0x8(%ebp),%eax
 8048f4e:	89 50 10             	mov    %edx,0x10(%eax)
 8048f51:	8b 45 08             	mov    0x8(%ebp),%eax
 8048f54:	a3 d4 72 0b 08       	mov    %eax,0x80b72d4
 8048f59:	5d                   	pop    %ebp
 8048f5a:	c3                   	ret    

08048f5b <init_game>:
 8048f5b:	55                   	push   %ebp
 8048f5c:	89 e5                	mov    %esp,%ebp
 8048f5e:	c7 05 d4 b3 04 08 9e 	movl   $0x9e,0x804b3d4
 8048f65:	00 00 00 
 8048f68:	c6 05 80 bb 04 08 00 	movb   $0x0,0x804bb80
 8048f6f:	5d                   	pop    %ebp
 8048f70:	c3                   	ret    

08048f71 <get_y>:
 8048f71:	55                   	push   %ebp
 8048f72:	89 e5                	mov    %esp,%ebp
 8048f74:	a1 d4 b3 04 08       	mov    0x804b3d4,%eax
 8048f79:	5d                   	pop    %ebp
 8048f7a:	c3                   	ret    

08048f7b <move_left>:
 8048f7b:	55                   	push   %ebp
 8048f7c:	89 e5                	mov    %esp,%ebp
 8048f7e:	a1 d4 b3 04 08       	mov    0x804b3d4,%eax
 8048f83:	83 f8 0a             	cmp    $0xa,%eax
 8048f86:	7e 0d                	jle    8048f95 <move_left+0x1a>
 8048f88:	a1 d4 b3 04 08       	mov    0x804b3d4,%eax
 8048f8d:	83 e8 05             	sub    $0x5,%eax
 8048f90:	a3 d4 b3 04 08       	mov    %eax,0x804b3d4
 8048f95:	5d                   	pop    %ebp
 8048f96:	c3                   	ret    

08048f97 <move_right>:
 8048f97:	55                   	push   %ebp
 8048f98:	89 e5                	mov    %esp,%ebp
 8048f9a:	a1 d4 b3 04 08       	mov    0x804b3d4,%eax
 8048f9f:	3d 30 01 00 00       	cmp    $0x130,%eax
 8048fa4:	7f 0d                	jg     8048fb3 <move_right+0x1c>
 8048fa6:	a1 d4 b3 04 08       	mov    0x804b3d4,%eax
 8048fab:	83 c0 05             	add    $0x5,%eax
 8048fae:	a3 d4 b3 04 08       	mov    %eax,0x804b3d4
 8048fb3:	5d                   	pop    %ebp
 8048fb4:	c3                   	ret    

08048fb5 <get_hit>:
 8048fb5:	55                   	push   %ebp
 8048fb6:	89 e5                	mov    %esp,%ebp
 8048fb8:	a1 e0 72 0b 08       	mov    0x80b72e0,%eax
 8048fbd:	5d                   	pop    %ebp
 8048fbe:	c3                   	ret    

08048fbf <get_miss>:
 8048fbf:	55                   	push   %ebp
 8048fc0:	89 e5                	mov    %esp,%ebp
 8048fc2:	a1 e4 72 0b 08       	mov    0x80b72e4,%eax
 8048fc7:	5d                   	pop    %ebp
 8048fc8:	c3                   	ret    

08048fc9 <characters>:
 8048fc9:	55                   	push   %ebp
 8048fca:	89 e5                	mov    %esp,%ebp
 8048fcc:	a1 d8 72 0b 08       	mov    0x80b72d8,%eax
 8048fd1:	5d                   	pop    %ebp
 8048fd2:	c3                   	ret    

08048fd3 <buls>:
 8048fd3:	55                   	push   %ebp
 8048fd4:	89 e5                	mov    %esp,%ebp
 8048fd6:	a1 dc 72 0b 08       	mov    0x80b72dc,%eax
 8048fdb:	5d                   	pop    %ebp
 8048fdc:	c3                   	ret    

08048fdd <create_new_bullet>:
 8048fdd:	55                   	push   %ebp
 8048fde:	89 e5                	mov    %esp,%ebp
 8048fe0:	83 ec 28             	sub    $0x28,%esp
 8048fe3:	a1 dc 72 0b 08       	mov    0x80b72dc,%eax
 8048fe8:	85 c0                	test   %eax,%eax
 8048fea:	75 0c                	jne    8048ff8 <create_new_bullet+0x1b>
 8048fec:	e8 b3 fd ff ff       	call   8048da4 <bul_new>
 8048ff1:	a3 dc 72 0b 08       	mov    %eax,0x80b72dc
 8048ff6:	eb 26                	jmp    804901e <create_new_bullet+0x41>
 8048ff8:	e8 a7 fd ff ff       	call   8048da4 <bul_new>
 8048ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049000:	a1 dc 72 0b 08       	mov    0x80b72dc,%eax
 8049005:	83 ec 04             	sub    $0x4,%esp
 8049008:	ff 75 f4             	pushl  -0xc(%ebp)
 804900b:	50                   	push   %eax
 804900c:	6a 00                	push   $0x0
 804900e:	e8 89 fe ff ff       	call   8048e9c <bul_insert>
 8049013:	83 c4 10             	add    $0x10,%esp
 8049016:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049019:	a3 dc 72 0b 08       	mov    %eax,0x80b72dc
 804901e:	8b 15 dc 72 0b 08    	mov    0x80b72dc,%edx
 8049024:	a1 34 99 04 08       	mov    0x8049934,%eax
 8049029:	89 02                	mov    %eax,(%edx)
 804902b:	a1 dc 72 0b 08       	mov    0x80b72dc,%eax
 8049030:	8b 15 d4 b3 04 08    	mov    0x804b3d4,%edx
 8049036:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 8049039:	db 45 e4             	fildl  -0x1c(%ebp)
 804903c:	d9 58 04             	fstps  0x4(%eax)
 804903f:	8b 15 dc 72 0b 08    	mov    0x80b72dc,%edx
 8049045:	a1 38 99 04 08       	mov    0x8049938,%eax
 804904a:	89 42 08             	mov    %eax,0x8(%edx)
 804904d:	c9                   	leave  
 804904e:	c3                   	ret    

0804904f <create_new_letter>:
 804904f:	55                   	push   %ebp
 8049050:	89 e5                	mov    %esp,%ebp
 8049052:	53                   	push   %ebx
 8049053:	83 ec 24             	sub    $0x24,%esp
 8049056:	a1 d8 72 0b 08       	mov    0x80b72d8,%eax
 804905b:	85 c0                	test   %eax,%eax
 804905d:	75 0c                	jne    804906b <create_new_letter+0x1c>
 804905f:	e8 8b fb ff ff       	call   8048bef <fly_new>
 8049064:	a3 d8 72 0b 08       	mov    %eax,0x80b72d8
 8049069:	eb 26                	jmp    8049091 <create_new_letter+0x42>
 804906b:	e8 7f fb ff ff       	call   8048bef <fly_new>
 8049070:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049073:	a1 d8 72 0b 08       	mov    0x80b72d8,%eax
 8049078:	83 ec 04             	sub    $0x4,%esp
 804907b:	ff 75 f4             	pushl  -0xc(%ebp)
 804907e:	50                   	push   %eax
 804907f:	6a 00                	push   $0x0
 8049081:	e8 5f fc ff ff       	call   8048ce5 <fly_insert>
 8049086:	83 c4 10             	add    $0x10,%esp
 8049089:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804908c:	a3 d8 72 0b 08       	mov    %eax,0x80b72d8
 8049091:	8b 15 d8 72 0b 08    	mov    0x80b72d8,%edx
 8049097:	a1 3c 99 04 08       	mov    0x804993c,%eax
 804909c:	89 02                	mov    %eax,(%edx)
 804909e:	8b 1d d8 72 0b 08    	mov    0x80b72d8,%ebx
 80490a4:	e8 5d f2 ff ff       	call   8048306 <rand>
 80490a9:	89 c1                	mov    %eax,%ecx
 80490ab:	ba f3 1a ca 6b       	mov    $0x6bca1af3,%edx
 80490b0:	89 c8                	mov    %ecx,%eax
 80490b2:	f7 ea                	imul   %edx
 80490b4:	c1 fa 04             	sar    $0x4,%edx
 80490b7:	89 c8                	mov    %ecx,%eax
 80490b9:	c1 f8 1f             	sar    $0x1f,%eax
 80490bc:	29 c2                	sub    %eax,%edx
 80490be:	89 d0                	mov    %edx,%eax
 80490c0:	6b c0 26             	imul   $0x26,%eax,%eax
 80490c3:	29 c1                	sub    %eax,%ecx
 80490c5:	89 c8                	mov    %ecx,%eax
 80490c7:	83 c0 01             	add    $0x1,%eax
 80490ca:	c1 e0 03             	shl    $0x3,%eax
 80490cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
 80490d0:	db 45 e0             	fildl  -0x20(%ebp)
 80490d3:	d9 5b 04             	fstps  0x4(%ebx)
 80490d6:	8b 1d d8 72 0b 08    	mov    0x80b72d8,%ebx
 80490dc:	e8 25 f2 ff ff       	call   8048306 <rand>
 80490e1:	89 c1                	mov    %eax,%ecx
 80490e3:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 80490e8:	89 c8                	mov    %ecx,%eax
 80490ea:	f7 ea                	imul   %edx
 80490ec:	c1 fa 06             	sar    $0x6,%edx
 80490ef:	89 c8                	mov    %ecx,%eax
 80490f1:	c1 f8 1f             	sar    $0x1f,%eax
 80490f4:	29 c2                	sub    %eax,%edx
 80490f6:	89 d0                	mov    %edx,%eax
 80490f8:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 80490fe:	29 c1                	sub    %eax,%ecx
 8049100:	89 c8                	mov    %ecx,%eax
 8049102:	89 45 e0             	mov    %eax,-0x20(%ebp)
 8049105:	db 45 e0             	fildl  -0x20(%ebp)
 8049108:	dd 05 40 99 04 08    	fldl   0x8049940
 804910e:	de f9                	fdivrp %st,%st(1)
 8049110:	d9 e8                	fld1   
 8049112:	de c1                	faddp  %st,%st(1)
 8049114:	dd 05 48 99 04 08    	fldl   0x8049948
 804911a:	de f9                	fdivrp %st,%st(1)
 804911c:	d9 5d e4             	fstps  -0x1c(%ebp)
 804911f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8049122:	89 43 0c             	mov    %eax,0xc(%ebx)
 8049125:	a1 d8 72 0b 08       	mov    0x80b72d8,%eax
 804912a:	c7 40 08 14 00 00 00 	movl   $0x14,0x8(%eax)
 8049131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8049134:	c9                   	leave  
 8049135:	c3                   	ret    

08049136 <update_letter_pos>:
 8049136:	55                   	push   %ebp
 8049137:	89 e5                	mov    %esp,%ebp
 8049139:	83 ec 28             	sub    $0x28,%esp
 804913c:	a1 d8 72 0b 08       	mov    0x80b72d8,%eax
 8049141:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049144:	e9 fe 00 00 00       	jmp    8049247 <update_letter_pos+0x111>
 8049149:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804914c:	8b 40 14             	mov    0x14(%eax),%eax
 804914f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8049152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049155:	d9 00                	flds   (%eax)
 8049157:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804915a:	d9 40 0c             	flds   0xc(%eax)
 804915d:	de c1                	faddp  %st,%st(1)
 804915f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049162:	d9 18                	fstps  (%eax)
 8049164:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049167:	d9 00                	flds   (%eax)
 8049169:	d9 05 50 99 04 08    	flds   0x8049950
 804916f:	df e9                	fucomip %st(1),%st
 8049171:	dd d8                	fstp   %st(0)
 8049173:	72 5c                	jb     80491d1 <update_letter_pos+0x9b>
 8049175:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049178:	d9 00                	flds   (%eax)
 804917a:	d9 05 54 99 04 08    	flds   0x8049954
 8049180:	d9 c9                	fxch   %st(1)
 8049182:	df e9                	fucomip %st(1),%st
 8049184:	dd d8                	fstp   %st(0)
 8049186:	72 49                	jb     80491d1 <update_letter_pos+0x9b>
 8049188:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804918b:	d9 40 04             	flds   0x4(%eax)
 804918e:	a1 d4 b3 04 08       	mov    0x804b3d4,%eax
 8049193:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8049196:	db 45 e4             	fildl  -0x1c(%ebp)
 8049199:	de e9                	fsubrp %st,%st(1)
 804919b:	d9 05 58 99 04 08    	flds   0x8049958
 80491a1:	df e9                	fucomip %st(1),%st
 80491a3:	dd d8                	fstp   %st(0)
 80491a5:	72 2a                	jb     80491d1 <update_letter_pos+0x9b>
 80491a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80491aa:	d9 40 04             	flds   0x4(%eax)
 80491ad:	a1 d4 b3 04 08       	mov    0x804b3d4,%eax
 80491b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 80491b5:	db 45 e4             	fildl  -0x1c(%ebp)
 80491b8:	de e9                	fsubrp %st,%st(1)
 80491ba:	d9 05 5c 99 04 08    	flds   0x804995c
 80491c0:	d9 c9                	fxch   %st(1)
 80491c2:	df e9                	fucomip %st(1),%st
 80491c4:	dd d8                	fstp   %st(0)
 80491c6:	72 09                	jb     80491d1 <update_letter_pos+0x9b>
 80491c8:	c6 05 80 bb 04 08 01 	movb   $0x1,0x804bb80
 80491cf:	eb fe                	jmp    80491cf <update_letter_pos+0x99>
 80491d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80491d4:	d9 00                	flds   (%eax)
 80491d6:	d9 ee                	fldz   
 80491d8:	df e9                	fucomip %st(1),%st
 80491da:	dd d8                	fstp   %st(0)
 80491dc:	77 1b                	ja     80491f9 <update_letter_pos+0xc3>
 80491de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80491e1:	d9 00                	flds   (%eax)
 80491e3:	d9 05 60 99 04 08    	flds   0x8049960
 80491e9:	de c1                	faddp  %st,%st(1)
 80491eb:	d9 05 64 99 04 08    	flds   0x8049964
 80491f1:	d9 c9                	fxch   %st(1)
 80491f3:	df e9                	fucomip %st(1),%st
 80491f5:	dd d8                	fstp   %st(0)
 80491f7:	72 48                	jb     8049241 <update_letter_pos+0x10b>
 80491f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80491fc:	d9 00                	flds   (%eax)
 80491fe:	d9 ee                	fldz   
 8049200:	df e9                	fucomip %st(1),%st
 8049202:	dd d8                	fstp   %st(0)
 8049204:	77 0d                	ja     8049213 <update_letter_pos+0xdd>
 8049206:	a1 e4 72 0b 08       	mov    0x80b72e4,%eax
 804920b:	83 c0 01             	add    $0x1,%eax
 804920e:	a3 e4 72 0b 08       	mov    %eax,0x80b72e4
 8049213:	83 ec 0c             	sub    $0xc,%esp
 8049216:	ff 75 f4             	pushl  -0xc(%ebp)
 8049219:	e8 1d fb ff ff       	call   8048d3b <fly_remove>
 804921e:	83 c4 10             	add    $0x10,%esp
 8049221:	83 ec 0c             	sub    $0xc,%esp
 8049224:	ff 75 f4             	pushl  -0xc(%ebp)
 8049227:	e8 5f fb ff ff       	call   8048d8b <fly_free>
 804922c:	83 c4 10             	add    $0x10,%esp
 804922f:	a1 d8 72 0b 08       	mov    0x80b72d8,%eax
 8049234:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8049237:	75 08                	jne    8049241 <update_letter_pos+0x10b>
 8049239:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804923c:	a3 d8 72 0b 08       	mov    %eax,0x80b72d8
 8049241:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049244:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 804924b:	0f 85 f8 fe ff ff    	jne    8049149 <update_letter_pos+0x13>
 8049251:	a1 dc 72 0b 08       	mov    0x80b72dc,%eax
 8049256:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049259:	e9 84 00 00 00       	jmp    80492e2 <update_letter_pos+0x1ac>
 804925e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049261:	8b 40 10             	mov    0x10(%eax),%eax
 8049264:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8049267:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804926a:	d9 00                	flds   (%eax)
 804926c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804926f:	d9 40 08             	flds   0x8(%eax)
 8049272:	de c1                	faddp  %st,%st(1)
 8049274:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049277:	d9 18                	fstps  (%eax)
 8049279:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804927c:	d9 00                	flds   (%eax)
 804927e:	d9 ee                	fldz   
 8049280:	df e9                	fucomip %st(1),%st
 8049282:	dd d8                	fstp   %st(0)
 8049284:	77 1b                	ja     80492a1 <update_letter_pos+0x16b>
 8049286:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049289:	d9 00                	flds   (%eax)
 804928b:	dd 05 68 99 04 08    	fldl   0x8049968
 8049291:	de c1                	faddp  %st,%st(1)
 8049293:	dd 05 70 99 04 08    	fldl   0x8049970
 8049299:	d9 c9                	fxch   %st(1)
 804929b:	df e9                	fucomip %st(1),%st
 804929d:	dd d8                	fstp   %st(0)
 804929f:	76 3b                	jbe    80492dc <update_letter_pos+0x1a6>
 80492a1:	83 ec 0c             	sub    $0xc,%esp
 80492a4:	ff 75 f0             	pushl  -0x10(%ebp)
 80492a7:	e8 46 fc ff ff       	call   8048ef2 <bul_remove>
 80492ac:	83 c4 10             	add    $0x10,%esp
 80492af:	83 ec 0c             	sub    $0xc,%esp
 80492b2:	ff 75 f0             	pushl  -0x10(%ebp)
 80492b5:	e8 88 fc ff ff       	call   8048f42 <bul_free>
 80492ba:	83 c4 10             	add    $0x10,%esp
 80492bd:	a1 6c bb 04 08       	mov    0x804bb6c,%eax
 80492c2:	83 c0 01             	add    $0x1,%eax
 80492c5:	a3 6c bb 04 08       	mov    %eax,0x804bb6c
 80492ca:	a1 dc 72 0b 08       	mov    0x80b72dc,%eax
 80492cf:	39 45 f0             	cmp    %eax,-0x10(%ebp)
 80492d2:	75 08                	jne    80492dc <update_letter_pos+0x1a6>
 80492d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80492d7:	a3 dc 72 0b 08       	mov    %eax,0x80b72dc
 80492dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80492df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80492e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 80492e6:	0f 85 72 ff ff ff    	jne    804925e <update_letter_pos+0x128>
 80492ec:	c9                   	leave  
 80492ed:	c3                   	ret    

080492ee <update_keypress>:
 80492ee:	55                   	push   %ebp
 80492ef:	89 e5                	mov    %esp,%ebp
 80492f1:	83 ec 18             	sub    $0x18,%esp
 80492f4:	e8 f0 f8 ff ff       	call   8048be9 <disable_interrupt>
 80492f9:	a1 d8 72 0b 08       	mov    0x80b72d8,%eax
 80492fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049301:	e9 16 01 00 00       	jmp    804941c <update_keypress+0x12e>
 8049306:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049309:	8b 40 14             	mov    0x14(%eax),%eax
 804930c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804930f:	a1 dc 72 0b 08       	mov    0x80b72dc,%eax
 8049314:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049317:	e9 f0 00 00 00       	jmp    804940c <update_keypress+0x11e>
 804931c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804931f:	8b 40 10             	mov    0x10(%eax),%eax
 8049322:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8049325:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049328:	d9 00                	flds   (%eax)
 804932a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804932d:	d9 00                	flds   (%eax)
 804932f:	de e9                	fsubrp %st,%st(1)
 8049331:	d9 05 58 99 04 08    	flds   0x8049958
 8049337:	df e9                	fucomip %st(1),%st
 8049339:	dd d8                	fstp   %st(0)
 804933b:	0f 82 c5 00 00 00    	jb     8049406 <update_keypress+0x118>
 8049341:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049344:	d9 00                	flds   (%eax)
 8049346:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049349:	d9 00                	flds   (%eax)
 804934b:	de e9                	fsubrp %st,%st(1)
 804934d:	d9 05 5c 99 04 08    	flds   0x804995c
 8049353:	d9 c9                	fxch   %st(1)
 8049355:	df e9                	fucomip %st(1),%st
 8049357:	dd d8                	fstp   %st(0)
 8049359:	0f 82 a7 00 00 00    	jb     8049406 <update_keypress+0x118>
 804935f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049362:	d9 40 04             	flds   0x4(%eax)
 8049365:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049368:	d9 40 04             	flds   0x4(%eax)
 804936b:	de e9                	fsubrp %st,%st(1)
 804936d:	d9 05 58 99 04 08    	flds   0x8049958
 8049373:	df e9                	fucomip %st(1),%st
 8049375:	dd d8                	fstp   %st(0)
 8049377:	0f 82 89 00 00 00    	jb     8049406 <update_keypress+0x118>
 804937d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049380:	d9 40 04             	flds   0x4(%eax)
 8049383:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049386:	d9 40 04             	flds   0x4(%eax)
 8049389:	de e9                	fsubrp %st,%st(1)
 804938b:	d9 05 5c 99 04 08    	flds   0x804995c
 8049391:	d9 c9                	fxch   %st(1)
 8049393:	df e9                	fucomip %st(1),%st
 8049395:	dd d8                	fstp   %st(0)
 8049397:	72 6d                	jb     8049406 <update_keypress+0x118>
 8049399:	a1 e0 72 0b 08       	mov    0x80b72e0,%eax
 804939e:	83 c0 01             	add    $0x1,%eax
 80493a1:	a3 e0 72 0b 08       	mov    %eax,0x80b72e0
 80493a6:	83 ec 0c             	sub    $0xc,%esp
 80493a9:	ff 75 f4             	pushl  -0xc(%ebp)
 80493ac:	e8 8a f9 ff ff       	call   8048d3b <fly_remove>
 80493b1:	83 c4 10             	add    $0x10,%esp
 80493b4:	83 ec 0c             	sub    $0xc,%esp
 80493b7:	ff 75 f4             	pushl  -0xc(%ebp)
 80493ba:	e8 cc f9 ff ff       	call   8048d8b <fly_free>
 80493bf:	83 c4 10             	add    $0x10,%esp
 80493c2:	83 ec 0c             	sub    $0xc,%esp
 80493c5:	ff 75 f0             	pushl  -0x10(%ebp)
 80493c8:	e8 25 fb ff ff       	call   8048ef2 <bul_remove>
 80493cd:	83 c4 10             	add    $0x10,%esp
 80493d0:	83 ec 0c             	sub    $0xc,%esp
 80493d3:	ff 75 f0             	pushl  -0x10(%ebp)
 80493d6:	e8 67 fb ff ff       	call   8048f42 <bul_free>
 80493db:	83 c4 10             	add    $0x10,%esp
 80493de:	a1 d8 72 0b 08       	mov    0x80b72d8,%eax
 80493e3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80493e6:	75 08                	jne    80493f0 <update_keypress+0x102>
 80493e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80493eb:	a3 d8 72 0b 08       	mov    %eax,0x80b72d8
 80493f0:	a1 dc 72 0b 08       	mov    0x80b72dc,%eax
 80493f5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
 80493f8:	75 0a                	jne    8049404 <update_keypress+0x116>
 80493fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80493fd:	a3 dc 72 0b 08       	mov    %eax,0x80b72dc
 8049402:	eb 12                	jmp    8049416 <update_keypress+0x128>
 8049404:	eb 10                	jmp    8049416 <update_keypress+0x128>
 8049406:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049409:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804940c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8049410:	0f 85 06 ff ff ff    	jne    804931c <update_keypress+0x2e>
 8049416:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049419:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804941c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8049420:	0f 85 e0 fe ff ff    	jne    8049306 <update_keypress+0x18>
 8049426:	e8 b8 f7 ff ff       	call   8048be3 <enable_interrupt>
 804942b:	b8 00 00 00 00       	mov    $0x0,%eax
 8049430:	c9                   	leave  
 8049431:	c3                   	ret    

08049432 <out_byte>:
 8049432:	55                   	push   %ebp
 8049433:	89 e5                	mov    %esp,%ebp
 8049435:	83 ec 08             	sub    $0x8,%esp
 8049438:	8b 55 08             	mov    0x8(%ebp),%edx
 804943b:	8b 45 0c             	mov    0xc(%ebp),%eax
 804943e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
 8049442:	88 45 f8             	mov    %al,-0x8(%ebp)
 8049445:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
 8049449:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
 804944d:	ee                   	out    %al,(%dx)
 804944e:	c9                   	leave  
 804944f:	c3                   	ret    

08049450 <init_serial>:
 8049450:	55                   	push   %ebp
 8049451:	89 e5                	mov    %esp,%ebp
 8049453:	6a 00                	push   $0x0
 8049455:	68 f9 03 00 00       	push   $0x3f9
 804945a:	e8 d3 ff ff ff       	call   8049432 <out_byte>
 804945f:	83 c4 08             	add    $0x8,%esp
 8049462:	6a 80                	push   $0xffffff80
 8049464:	68 fb 03 00 00       	push   $0x3fb
 8049469:	e8 c4 ff ff ff       	call   8049432 <out_byte>
 804946e:	83 c4 08             	add    $0x8,%esp
 8049471:	6a 01                	push   $0x1
 8049473:	68 f8 03 00 00       	push   $0x3f8
 8049478:	e8 b5 ff ff ff       	call   8049432 <out_byte>
 804947d:	83 c4 08             	add    $0x8,%esp
 8049480:	6a 00                	push   $0x0
 8049482:	68 f9 03 00 00       	push   $0x3f9
 8049487:	e8 a6 ff ff ff       	call   8049432 <out_byte>
 804948c:	83 c4 08             	add    $0x8,%esp
 804948f:	6a 03                	push   $0x3
 8049491:	68 fb 03 00 00       	push   $0x3fb
 8049496:	e8 97 ff ff ff       	call   8049432 <out_byte>
 804949b:	83 c4 08             	add    $0x8,%esp
 804949e:	6a c7                	push   $0xffffffc7
 80494a0:	68 fa 03 00 00       	push   $0x3fa
 80494a5:	e8 88 ff ff ff       	call   8049432 <out_byte>
 80494aa:	83 c4 08             	add    $0x8,%esp
 80494ad:	6a 0b                	push   $0xb
 80494af:	68 fc 03 00 00       	push   $0x3fc
 80494b4:	e8 79 ff ff ff       	call   8049432 <out_byte>
 80494b9:	83 c4 08             	add    $0x8,%esp
 80494bc:	c9                   	leave  
 80494bd:	c3                   	ret    

080494be <serial_printc>:
 80494be:	55                   	push   %ebp
 80494bf:	89 e5                	mov    %esp,%ebp
 80494c1:	83 ec 04             	sub    $0x4,%esp
 80494c4:	8b 45 08             	mov    0x8(%ebp),%eax
 80494c7:	88 45 fc             	mov    %al,-0x4(%ebp)
 80494ca:	b8 01 00 00 00       	mov    $0x1,%eax
 80494cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
 80494d2:	cd 80                	int    $0x80
 80494d4:	c9                   	leave  
 80494d5:	c3                   	ret    

080494d6 <out_byte>:
 80494d6:	55                   	push   %ebp
 80494d7:	89 e5                	mov    %esp,%ebp
 80494d9:	83 ec 08             	sub    $0x8,%esp
 80494dc:	8b 55 08             	mov    0x8(%ebp),%edx
 80494df:	8b 45 0c             	mov    0xc(%ebp),%eax
 80494e2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
 80494e6:	88 45 f8             	mov    %al,-0x8(%ebp)
 80494e9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
 80494ed:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
 80494f1:	ee                   	out    %al,(%dx)
 80494f2:	c9                   	leave  
 80494f3:	c3                   	ret    

080494f4 <init_timer>:
 80494f4:	55                   	push   %ebp
 80494f5:	89 e5                	mov    %esp,%ebp
 80494f7:	83 ec 18             	sub    $0x18,%esp
 80494fa:	c7 45 f4 a9 04 00 00 	movl   $0x4a9,-0xc(%ebp)
 8049501:	81 7d f4 ff ff 00 00 	cmpl   $0xffff,-0xc(%ebp)
 8049508:	7e 12                	jle    804951c <init_timer+0x28>
 804950a:	83 ec 08             	sub    $0x8,%esp
 804950d:	6a 0c                	push   $0xc
 804950f:	68 78 99 04 08       	push   $0x8049978
 8049514:	e8 af f3 ff ff       	call   80488c8 <abort>
 8049519:	83 c4 10             	add    $0x10,%esp
 804951c:	83 ec 08             	sub    $0x8,%esp
 804951f:	6a 34                	push   $0x34
 8049521:	6a 43                	push   $0x43
 8049523:	e8 ae ff ff ff       	call   80494d6 <out_byte>
 8049528:	83 c4 10             	add    $0x10,%esp
 804952b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804952e:	99                   	cltd   
 804952f:	c1 ea 18             	shr    $0x18,%edx
 8049532:	01 d0                	add    %edx,%eax
 8049534:	0f b6 c0             	movzbl %al,%eax
 8049537:	29 d0                	sub    %edx,%eax
 8049539:	0f be c0             	movsbl %al,%eax
 804953c:	83 ec 08             	sub    $0x8,%esp
 804953f:	50                   	push   %eax
 8049540:	6a 40                	push   $0x40
 8049542:	e8 8f ff ff ff       	call   80494d6 <out_byte>
 8049547:	83 c4 10             	add    $0x10,%esp
 804954a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804954d:	8d 90 ff 00 00 00    	lea    0xff(%eax),%edx
 8049553:	85 c0                	test   %eax,%eax
 8049555:	0f 48 c2             	cmovs  %edx,%eax
 8049558:	c1 f8 08             	sar    $0x8,%eax
 804955b:	0f be c0             	movsbl %al,%eax
 804955e:	83 ec 08             	sub    $0x8,%esp
 8049561:	50                   	push   %eax
 8049562:	6a 40                	push   $0x40
 8049564:	e8 6d ff ff ff       	call   80494d6 <out_byte>
 8049569:	83 c4 10             	add    $0x10,%esp
 804956c:	c9                   	leave  
 804956d:	c3                   	ret    

0804956e <draw_pixel>:
 804956e:	55                   	push   %ebp
 804956f:	89 e5                	mov    %esp,%ebp
 8049571:	83 ec 08             	sub    $0x8,%esp
 8049574:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8049578:	78 06                	js     8049580 <draw_pixel+0x12>
 804957a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 804957e:	79 12                	jns    8049592 <draw_pixel+0x24>
 8049580:	83 ec 08             	sub    $0x8,%esp
 8049583:	6a 13                	push   $0x13
 8049585:	68 90 99 04 08       	push   $0x8049990
 804958a:	e8 39 f3 ff ff       	call   80488c8 <abort>
 804958f:	83 c4 10             	add    $0x10,%esp
 8049592:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
 8049599:	7e 12                	jle    80495ad <draw_pixel+0x3f>
 804959b:	83 ec 08             	sub    $0x8,%esp
 804959e:	6a 14                	push   $0x14
 80495a0:	68 90 99 04 08       	push   $0x8049990
 80495a5:	e8 1e f3 ff ff       	call   80488c8 <abort>
 80495aa:	83 c4 10             	add    $0x10,%esp
 80495ad:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
 80495b4:	7e 12                	jle    80495c8 <draw_pixel+0x5a>
 80495b6:	83 ec 08             	sub    $0x8,%esp
 80495b9:	6a 15                	push   $0x15
 80495bb:	68 90 99 04 08       	push   $0x8049990
 80495c0:	e8 03 f3 ff ff       	call   80488c8 <abort>
 80495c5:	83 c4 10             	add    $0x10,%esp
 80495c8:	8b 45 08             	mov    0x8(%ebp),%eax
 80495cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80495ce:	8b 55 10             	mov    0x10(%ebp),%edx
 80495d1:	cd 81                	int    $0x81
 80495d3:	c9                   	leave  
 80495d4:	c3                   	ret    

080495d5 <prepare_buffer>:
 80495d5:	55                   	push   %ebp
 80495d6:	89 e5                	mov    %esp,%ebp
 80495d8:	83 ec 08             	sub    $0x8,%esp
 80495db:	83 ec 04             	sub    $0x4,%esp
 80495de:	68 00 fa 00 00       	push   $0xfa00
 80495e3:	68 00 73 0b 08       	push   $0x80b7300
 80495e8:	68 00 6d 0c 08       	push   $0x80c6d00
 80495ed:	e8 9f ed ff ff       	call   8048391 <memcpy>
 80495f2:	83 c4 10             	add    $0x10,%esp
 80495f5:	c7 05 00 b8 04 08 00 	movl   $0x80b7300,0x804b800
 80495fc:	73 0b 08 
 80495ff:	a1 00 b8 04 08       	mov    0x804b800,%eax
 8049604:	83 ec 04             	sub    $0x4,%esp
 8049607:	68 00 fa 00 00       	push   $0xfa00
 804960c:	6a 00                	push   $0x0
 804960e:	50                   	push   %eax
 804960f:	e8 9a ed ff ff       	call   80483ae <memset>
 8049614:	83 c4 10             	add    $0x10,%esp
 8049617:	c9                   	leave  
 8049618:	c3                   	ret    

08049619 <display_buffer>:
 8049619:	55                   	push   %ebp
 804961a:	89 e5                	mov    %esp,%ebp
 804961c:	83 ec 10             	sub    $0x10,%esp
 804961f:	c7 45 f8 00 73 0b 08 	movl   $0x80b7300,-0x8(%ebp)
 8049626:	c7 45 f4 00 6d 0c 08 	movl   $0x80c6d00,-0xc(%ebp)
 804962d:	c7 45 f0 00 00 0a 00 	movl   $0xa0000,-0x10(%ebp)
 8049634:	c7 05 00 b8 04 08 00 	movl   $0xa0000,0x804b800
 804963b:	00 0a 00 
 804963e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8049645:	eb 4c                	jmp    8049693 <display_buffer+0x7a>
 8049647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804964a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 8049651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8049654:	01 d0                	add    %edx,%eax
 8049656:	8b 10                	mov    (%eax),%edx
 8049658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804965b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
 8049662:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049665:	01 c8                	add    %ecx,%eax
 8049667:	8b 00                	mov    (%eax),%eax
 8049669:	39 c2                	cmp    %eax,%edx
 804966b:	74 22                	je     804968f <display_buffer+0x76>
 804966d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8049670:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 8049677:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804967a:	01 c2                	add    %eax,%edx
 804967c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804967f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
 8049686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8049689:	01 c8                	add    %ecx,%eax
 804968b:	8b 00                	mov    (%eax),%eax
 804968d:	89 02                	mov    %eax,(%edx)
 804968f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8049693:	81 7d fc 7f 3e 00 00 	cmpl   $0x3e7f,-0x4(%ebp)
 804969a:	7e ab                	jle    8049647 <display_buffer+0x2e>
 804969c:	c9                   	leave  
 804969d:	c3                   	ret    

0804969e <draw_character>:
 804969e:	55                   	push   %ebp
 804969f:	89 e5                	mov    %esp,%ebp
 80496a1:	83 ec 28             	sub    $0x28,%esp
 80496a4:	8b 45 08             	mov    0x8(%ebp),%eax
 80496a7:	88 45 e4             	mov    %al,-0x1c(%ebp)
 80496aa:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
 80496ae:	79 12                	jns    80496c2 <draw_character+0x24>
 80496b0:	83 ec 08             	sub    $0x8,%esp
 80496b3:	6a 47                	push   $0x47
 80496b5:	68 a9 99 04 08       	push   $0x80499a9
 80496ba:	e8 09 f2 ff ff       	call   80488c8 <abort>
 80496bf:	83 c4 10             	add    $0x10,%esp
 80496c2:	0f be 45 e4          	movsbl -0x1c(%ebp),%eax
 80496c6:	c1 e0 03             	shl    $0x3,%eax
 80496c9:	05 00 b4 04 08       	add    $0x804b400,%eax
 80496ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
 80496d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 80496d8:	eb 55                	jmp    804972f <draw_character+0x91>
 80496da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80496e1:	eb 42                	jmp    8049725 <draw_character+0x87>
 80496e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 80496e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80496e9:	01 d0                	add    %edx,%eax
 80496eb:	0f b6 00             	movzbl (%eax),%eax
 80496ee:	0f be d0             	movsbl %al,%edx
 80496f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80496f4:	89 c1                	mov    %eax,%ecx
 80496f6:	d3 fa                	sar    %cl,%edx
 80496f8:	89 d0                	mov    %edx,%eax
 80496fa:	83 e0 01             	and    $0x1,%eax
 80496fd:	85 c0                	test   %eax,%eax
 80496ff:	74 20                	je     8049721 <draw_character+0x83>
 8049701:	8b 55 10             	mov    0x10(%ebp),%edx
 8049704:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049707:	01 c2                	add    %eax,%edx
 8049709:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 804970c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804970f:	01 c8                	add    %ecx,%eax
 8049711:	83 ec 04             	sub    $0x4,%esp
 8049714:	ff 75 14             	pushl  0x14(%ebp)
 8049717:	52                   	push   %edx
 8049718:	50                   	push   %eax
 8049719:	e8 50 fe ff ff       	call   804956e <draw_pixel>
 804971e:	83 c4 10             	add    $0x10,%esp
 8049721:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8049725:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
 8049729:	7e b8                	jle    80496e3 <draw_character+0x45>
 804972b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804972f:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
 8049733:	7e a5                	jle    80496da <draw_character+0x3c>
 8049735:	c9                   	leave  
 8049736:	c3                   	ret    

08049737 <draw_string>:
 8049737:	55                   	push   %ebp
 8049738:	89 e5                	mov    %esp,%ebp
 804973a:	83 ec 08             	sub    $0x8,%esp
 804973d:	eb 3f                	jmp    804977e <draw_string+0x47>
 804973f:	8b 45 08             	mov    0x8(%ebp),%eax
 8049742:	8d 50 01             	lea    0x1(%eax),%edx
 8049745:	89 55 08             	mov    %edx,0x8(%ebp)
 8049748:	0f b6 00             	movzbl (%eax),%eax
 804974b:	0f be c0             	movsbl %al,%eax
 804974e:	ff 75 14             	pushl  0x14(%ebp)
 8049751:	ff 75 10             	pushl  0x10(%ebp)
 8049754:	ff 75 0c             	pushl  0xc(%ebp)
 8049757:	50                   	push   %eax
 8049758:	e8 41 ff ff ff       	call   804969e <draw_character>
 804975d:	83 c4 10             	add    $0x10,%esp
 8049760:	8b 45 10             	mov    0x10(%ebp),%eax
 8049763:	83 c0 08             	add    $0x8,%eax
 8049766:	3d 3f 01 00 00       	cmp    $0x13f,%eax
 804976b:	7e 0d                	jle    804977a <draw_string+0x43>
 804976d:	83 45 0c 08          	addl   $0x8,0xc(%ebp)
 8049771:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
 8049778:	eb 04                	jmp    804977e <draw_string+0x47>
 804977a:	83 45 10 08          	addl   $0x8,0x10(%ebp)
 804977e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049781:	0f b6 00             	movzbl (%eax),%eax
 8049784:	84 c0                	test   %al,%al
 8049786:	75 b7                	jne    804973f <draw_string+0x8>
 8049788:	c9                   	leave  
 8049789:	c3                   	ret    

0804978a <in_byte>:
 804978a:	55                   	push   %ebp
 804978b:	89 e5                	mov    %esp,%ebp
 804978d:	83 ec 14             	sub    $0x14,%esp
 8049790:	8b 45 08             	mov    0x8(%ebp),%eax
 8049793:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
 8049797:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
 804979b:	89 c2                	mov    %eax,%edx
 804979d:	ec                   	in     (%dx),%al
 804979e:	88 45 ff             	mov    %al,-0x1(%ebp)
 80497a1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
 80497a5:	c9                   	leave  
 80497a6:	c3                   	ret    

080497a7 <out_byte>:
 80497a7:	55                   	push   %ebp
 80497a8:	89 e5                	mov    %esp,%ebp
 80497aa:	83 ec 08             	sub    $0x8,%esp
 80497ad:	8b 55 08             	mov    0x8(%ebp),%edx
 80497b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 80497b3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
 80497b7:	88 45 f8             	mov    %al,-0x8(%ebp)
 80497ba:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
 80497be:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
 80497c2:	ee                   	out    %al,(%dx)
 80497c3:	c9                   	leave  
 80497c4:	c3                   	ret    

080497c5 <write_palette>:
 80497c5:	55                   	push   %ebp
 80497c6:	89 e5                	mov    %esp,%ebp
 80497c8:	83 ec 10             	sub    $0x10,%esp
 80497cb:	6a 00                	push   $0x0
 80497cd:	68 c8 03 00 00       	push   $0x3c8
 80497d2:	e8 d0 ff ff ff       	call   80497a7 <out_byte>
 80497d7:	83 c4 08             	add    $0x8,%esp
 80497da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 80497e1:	eb 79                	jmp    804985c <write_palette+0x97>
 80497e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 80497e6:	89 d0                	mov    %edx,%eax
 80497e8:	01 c0                	add    %eax,%eax
 80497ea:	01 d0                	add    %edx,%eax
 80497ec:	05 40 b8 04 08       	add    $0x804b840,%eax
 80497f1:	0f b6 00             	movzbl (%eax),%eax
 80497f4:	c0 e8 02             	shr    $0x2,%al
 80497f7:	0f be c0             	movsbl %al,%eax
 80497fa:	50                   	push   %eax
 80497fb:	68 c9 03 00 00       	push   $0x3c9
 8049800:	e8 a2 ff ff ff       	call   80497a7 <out_byte>
 8049805:	83 c4 08             	add    $0x8,%esp
 8049808:	8b 55 fc             	mov    -0x4(%ebp),%edx
 804980b:	89 d0                	mov    %edx,%eax
 804980d:	01 c0                	add    %eax,%eax
 804980f:	01 d0                	add    %edx,%eax
 8049811:	83 c0 01             	add    $0x1,%eax
 8049814:	05 40 b8 04 08       	add    $0x804b840,%eax
 8049819:	0f b6 00             	movzbl (%eax),%eax
 804981c:	c0 e8 02             	shr    $0x2,%al
 804981f:	0f be c0             	movsbl %al,%eax
 8049822:	50                   	push   %eax
 8049823:	68 c9 03 00 00       	push   $0x3c9
 8049828:	e8 7a ff ff ff       	call   80497a7 <out_byte>
 804982d:	83 c4 08             	add    $0x8,%esp
 8049830:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8049833:	89 d0                	mov    %edx,%eax
 8049835:	01 c0                	add    %eax,%eax
 8049837:	01 d0                	add    %edx,%eax
 8049839:	83 c0 02             	add    $0x2,%eax
 804983c:	05 40 b8 04 08       	add    $0x804b840,%eax
 8049841:	0f b6 00             	movzbl (%eax),%eax
 8049844:	c0 e8 02             	shr    $0x2,%al
 8049847:	0f be c0             	movsbl %al,%eax
 804984a:	50                   	push   %eax
 804984b:	68 c9 03 00 00       	push   $0x3c9
 8049850:	e8 52 ff ff ff       	call   80497a7 <out_byte>
 8049855:	83 c4 08             	add    $0x8,%esp
 8049858:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 804985c:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
 8049863:	0f 8e 7a ff ff ff    	jle    80497e3 <write_palette+0x1e>
 8049869:	c9                   	leave  
 804986a:	c3                   	ret    

0804986b <read_palette>:
 804986b:	55                   	push   %ebp
 804986c:	89 e5                	mov    %esp,%ebp
 804986e:	83 ec 18             	sub    $0x18,%esp
 8049871:	6a 00                	push   $0x0
 8049873:	68 c7 03 00 00       	push   $0x3c7
 8049878:	e8 2a ff ff ff       	call   80497a7 <out_byte>
 804987d:	83 c4 08             	add    $0x8,%esp
 8049880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8049887:	eb 50                	jmp    80498d9 <read_palette+0x6e>
 8049889:	68 c9 03 00 00       	push   $0x3c9
 804988e:	e8 f7 fe ff ff       	call   804978a <in_byte>
 8049893:	83 c4 04             	add    $0x4,%esp
 8049896:	88 45 f3             	mov    %al,-0xd(%ebp)
 8049899:	68 c9 03 00 00       	push   $0x3c9
 804989e:	e8 e7 fe ff ff       	call   804978a <in_byte>
 80498a3:	83 c4 04             	add    $0x4,%esp
 80498a6:	88 45 f2             	mov    %al,-0xe(%ebp)
 80498a9:	68 c9 03 00 00       	push   $0x3c9
 80498ae:	e8 d7 fe ff ff       	call   804978a <in_byte>
 80498b3:	83 c4 04             	add    $0x4,%esp
 80498b6:	88 45 f1             	mov    %al,-0xf(%ebp)
 80498b9:	0f b6 4d f1          	movzbl -0xf(%ebp),%ecx
 80498bd:	0f b6 55 f2          	movzbl -0xe(%ebp),%edx
 80498c1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 80498c5:	51                   	push   %ecx
 80498c6:	52                   	push   %edx
 80498c7:	50                   	push   %eax
 80498c8:	68 c1 99 04 08       	push   $0x80499c1
 80498cd:	e8 17 ef ff ff       	call   80487e9 <printk>
 80498d2:	83 c4 10             	add    $0x10,%esp
 80498d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80498d9:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
 80498e0:	7e a7                	jle    8049889 <read_palette+0x1e>
 80498e2:	c9                   	leave  
 80498e3:	c3                   	ret    
