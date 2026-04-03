
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	e062                	sd	s8,0(sp)
 130:	0880                	addi	s0,sp,80
 132:	89aa                	mv	s3,a0
 134:	8b2e                	mv	s6,a1
  m = 0;
 136:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 138:	3ff00b93          	li	s7,1023
 13c:	00001a97          	auipc	s5,0x1
 140:	364a8a93          	addi	s5,s5,868 # 14a0 <buf>
 144:	a0a1                	j	18c <grep+0x72>
      p = q+1;
 146:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 14a:	45a9                	li	a1,10
 14c:	854a                	mv	a0,s2
 14e:	00000097          	auipc	ra,0x0
 152:	20a080e7          	jalr	522(ra) # 358 <strchr>
 156:	84aa                	mv	s1,a0
 158:	c905                	beqz	a0,188 <grep+0x6e>
      *q = 0;
 15a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15e:	85ca                	mv	a1,s2
 160:	854e                	mv	a0,s3
 162:	00000097          	auipc	ra,0x0
 166:	f6a080e7          	jalr	-150(ra) # cc <match>
 16a:	dd71                	beqz	a0,146 <grep+0x2c>
        *q = '\n';
 16c:	47a9                	li	a5,10
 16e:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 172:	00148613          	addi	a2,s1,1
 176:	4126063b          	subw	a2,a2,s2
 17a:	85ca                	mv	a1,s2
 17c:	4505                	li	a0,1
 17e:	00000097          	auipc	ra,0x0
 182:	3d2080e7          	jalr	978(ra) # 550 <write>
 186:	b7c1                	j	146 <grep+0x2c>
    if(m > 0){
 188:	03404763          	bgtz	s4,1b6 <grep+0x9c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18c:	414b863b          	subw	a2,s7,s4
 190:	014a85b3          	add	a1,s5,s4
 194:	855a                	mv	a0,s6
 196:	00000097          	auipc	ra,0x0
 19a:	3b2080e7          	jalr	946(ra) # 548 <read>
 19e:	02a05b63          	blez	a0,1d4 <grep+0xba>
    m += n;
 1a2:	00aa0c3b          	addw	s8,s4,a0
 1a6:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 1aa:	014a87b3          	add	a5,s5,s4
 1ae:	00078023          	sb	zero,0(a5)
    p = buf;
 1b2:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1b4:	bf59                	j	14a <grep+0x30>
      m -= p - buf;
 1b6:	00001517          	auipc	a0,0x1
 1ba:	2ea50513          	addi	a0,a0,746 # 14a0 <buf>
 1be:	40a90a33          	sub	s4,s2,a0
 1c2:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1c6:	8652                	mv	a2,s4
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	2b4080e7          	jalr	692(ra) # 47e <memmove>
 1d2:	bf6d                	j	18c <grep+0x72>
}
 1d4:	60a6                	ld	ra,72(sp)
 1d6:	6406                	ld	s0,64(sp)
 1d8:	74e2                	ld	s1,56(sp)
 1da:	7942                	ld	s2,48(sp)
 1dc:	79a2                	ld	s3,40(sp)
 1de:	7a02                	ld	s4,32(sp)
 1e0:	6ae2                	ld	s5,24(sp)
 1e2:	6b42                	ld	s6,16(sp)
 1e4:	6ba2                	ld	s7,8(sp)
 1e6:	6c02                	ld	s8,0(sp)
 1e8:	6161                	addi	sp,sp,80
 1ea:	8082                	ret

00000000000001ec <main>:
{
 1ec:	7179                	addi	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1fc:	4785                	li	a5,1
 1fe:	04a7de63          	bge	a5,a0,25a <main+0x6e>
  pattern = argv[1];
 202:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 206:	4789                	li	a5,2
 208:	06a7d763          	bge	a5,a0,276 <main+0x8a>
 20c:	01058913          	addi	s2,a1,16
 210:	ffd5099b          	addiw	s3,a0,-3
 214:	02099793          	slli	a5,s3,0x20
 218:	01d7d993          	srli	s3,a5,0x1d
 21c:	05e1                	addi	a1,a1,24
 21e:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 220:	4581                	li	a1,0
 222:	00093503          	ld	a0,0(s2)
 226:	00000097          	auipc	ra,0x0
 22a:	34a080e7          	jalr	842(ra) # 570 <open>
 22e:	84aa                	mv	s1,a0
 230:	04054e63          	bltz	a0,28c <main+0xa0>
    grep(pattern, fd);
 234:	85aa                	mv	a1,a0
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	ee2080e7          	jalr	-286(ra) # 11a <grep>
    close(fd);
 240:	8526                	mv	a0,s1
 242:	00000097          	auipc	ra,0x0
 246:	316080e7          	jalr	790(ra) # 558 <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	addi	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x34>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	2de080e7          	jalr	734(ra) # 530 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00001597          	auipc	a1,0x1
 25e:	98658593          	addi	a1,a1,-1658 # be0 <malloc+0x142>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	61e080e7          	jalr	1566(ra) # 882 <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	2c2080e7          	jalr	706(ra) # 530 <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	2ac080e7          	jalr	684(ra) # 530 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00001517          	auipc	a0,0x1
 294:	97050513          	addi	a0,a0,-1680 # c00 <malloc+0x162>
 298:	00000097          	auipc	ra,0x0
 29c:	618080e7          	jalr	1560(ra) # 8b0 <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	28e080e7          	jalr	654(ra) # 530 <exit>

00000000000002aa <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2b2:	00000097          	auipc	ra,0x0
 2b6:	f3a080e7          	jalr	-198(ra) # 1ec <main>
  exit(0);
 2ba:	4501                	li	a0,0
 2bc:	00000097          	auipc	ra,0x0
 2c0:	274080e7          	jalr	628(ra) # 530 <exit>

00000000000002c4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ca:	87aa                	mv	a5,a0
 2cc:	0585                	addi	a1,a1,1
 2ce:	0785                	addi	a5,a5,1
 2d0:	fff5c703          	lbu	a4,-1(a1)
 2d4:	fee78fa3          	sb	a4,-1(a5)
 2d8:	fb75                	bnez	a4,2cc <strcpy+0x8>
    ;
  return os;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	cb91                	beqz	a5,2fe <strcmp+0x1e>
 2ec:	0005c703          	lbu	a4,0(a1)
 2f0:	00f71763          	bne	a4,a5,2fe <strcmp+0x1e>
    p++, q++;
 2f4:	0505                	addi	a0,a0,1
 2f6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	fbe5                	bnez	a5,2ec <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2fe:	0005c503          	lbu	a0,0(a1)
}
 302:	40a7853b          	subw	a0,a5,a0
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <strlen>:

uint
strlen(const char *s)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 312:	00054783          	lbu	a5,0(a0)
 316:	cf91                	beqz	a5,332 <strlen+0x26>
 318:	0505                	addi	a0,a0,1
 31a:	87aa                	mv	a5,a0
 31c:	86be                	mv	a3,a5
 31e:	0785                	addi	a5,a5,1
 320:	fff7c703          	lbu	a4,-1(a5)
 324:	ff65                	bnez	a4,31c <strlen+0x10>
 326:	40a6853b          	subw	a0,a3,a0
 32a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  for(n = 0; s[n]; n++)
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <strlen+0x20>

0000000000000336 <memset>:

void*
memset(void *dst, int c, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 33c:	ca19                	beqz	a2,352 <memset+0x1c>
 33e:	87aa                	mv	a5,a0
 340:	1602                	slli	a2,a2,0x20
 342:	9201                	srli	a2,a2,0x20
 344:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 348:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 34c:	0785                	addi	a5,a5,1
 34e:	fee79de3          	bne	a5,a4,348 <memset+0x12>
  }
  return dst;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret

0000000000000358 <strchr>:

char*
strchr(const char *s, char c)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 35e:	00054783          	lbu	a5,0(a0)
 362:	cb99                	beqz	a5,378 <strchr+0x20>
    if(*s == c)
 364:	00f58763          	beq	a1,a5,372 <strchr+0x1a>
  for(; *s; s++)
 368:	0505                	addi	a0,a0,1
 36a:	00054783          	lbu	a5,0(a0)
 36e:	fbfd                	bnez	a5,364 <strchr+0xc>
      return (char*)s;
  return 0;
 370:	4501                	li	a0,0
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret
  return 0;
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <strchr+0x1a>

000000000000037c <gets>:

char*
gets(char *buf, int max)
{
 37c:	711d                	addi	sp,sp,-96
 37e:	ec86                	sd	ra,88(sp)
 380:	e8a2                	sd	s0,80(sp)
 382:	e4a6                	sd	s1,72(sp)
 384:	e0ca                	sd	s2,64(sp)
 386:	fc4e                	sd	s3,56(sp)
 388:	f852                	sd	s4,48(sp)
 38a:	f456                	sd	s5,40(sp)
 38c:	f05a                	sd	s6,32(sp)
 38e:	ec5e                	sd	s7,24(sp)
 390:	1080                	addi	s0,sp,96
 392:	8baa                	mv	s7,a0
 394:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 396:	892a                	mv	s2,a0
 398:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 39a:	4aa9                	li	s5,10
 39c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 39e:	89a6                	mv	s3,s1
 3a0:	2485                	addiw	s1,s1,1
 3a2:	0344d863          	bge	s1,s4,3d2 <gets+0x56>
    cc = read(0, &c, 1);
 3a6:	4605                	li	a2,1
 3a8:	faf40593          	addi	a1,s0,-81
 3ac:	4501                	li	a0,0
 3ae:	00000097          	auipc	ra,0x0
 3b2:	19a080e7          	jalr	410(ra) # 548 <read>
    if(cc < 1)
 3b6:	00a05e63          	blez	a0,3d2 <gets+0x56>
    buf[i++] = c;
 3ba:	faf44783          	lbu	a5,-81(s0)
 3be:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3c2:	01578763          	beq	a5,s5,3d0 <gets+0x54>
 3c6:	0905                	addi	s2,s2,1
 3c8:	fd679be3          	bne	a5,s6,39e <gets+0x22>
    buf[i++] = c;
 3cc:	89a6                	mv	s3,s1
 3ce:	a011                	j	3d2 <gets+0x56>
 3d0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3d2:	99de                	add	s3,s3,s7
 3d4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3d8:	855e                	mv	a0,s7
 3da:	60e6                	ld	ra,88(sp)
 3dc:	6446                	ld	s0,80(sp)
 3de:	64a6                	ld	s1,72(sp)
 3e0:	6906                	ld	s2,64(sp)
 3e2:	79e2                	ld	s3,56(sp)
 3e4:	7a42                	ld	s4,48(sp)
 3e6:	7aa2                	ld	s5,40(sp)
 3e8:	7b02                	ld	s6,32(sp)
 3ea:	6be2                	ld	s7,24(sp)
 3ec:	6125                	addi	sp,sp,96
 3ee:	8082                	ret

00000000000003f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f0:	1101                	addi	sp,sp,-32
 3f2:	ec06                	sd	ra,24(sp)
 3f4:	e822                	sd	s0,16(sp)
 3f6:	e04a                	sd	s2,0(sp)
 3f8:	1000                	addi	s0,sp,32
 3fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3fc:	4581                	li	a1,0
 3fe:	00000097          	auipc	ra,0x0
 402:	172080e7          	jalr	370(ra) # 570 <open>
  if(fd < 0)
 406:	02054663          	bltz	a0,432 <stat+0x42>
 40a:	e426                	sd	s1,8(sp)
 40c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 40e:	85ca                	mv	a1,s2
 410:	00000097          	auipc	ra,0x0
 414:	178080e7          	jalr	376(ra) # 588 <fstat>
 418:	892a                	mv	s2,a0
  close(fd);
 41a:	8526                	mv	a0,s1
 41c:	00000097          	auipc	ra,0x0
 420:	13c080e7          	jalr	316(ra) # 558 <close>
  return r;
 424:	64a2                	ld	s1,8(sp)
}
 426:	854a                	mv	a0,s2
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6902                	ld	s2,0(sp)
 42e:	6105                	addi	sp,sp,32
 430:	8082                	ret
    return -1;
 432:	597d                	li	s2,-1
 434:	bfcd                	j	426 <stat+0x36>

0000000000000436 <atoi>:

int
atoi(const char *s)
{
 436:	1141                	addi	sp,sp,-16
 438:	e422                	sd	s0,8(sp)
 43a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 43c:	00054683          	lbu	a3,0(a0)
 440:	fd06879b          	addiw	a5,a3,-48
 444:	0ff7f793          	zext.b	a5,a5
 448:	4625                	li	a2,9
 44a:	02f66863          	bltu	a2,a5,47a <atoi+0x44>
 44e:	872a                	mv	a4,a0
  n = 0;
 450:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 452:	0705                	addi	a4,a4,1
 454:	0025179b          	slliw	a5,a0,0x2
 458:	9fa9                	addw	a5,a5,a0
 45a:	0017979b          	slliw	a5,a5,0x1
 45e:	9fb5                	addw	a5,a5,a3
 460:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 464:	00074683          	lbu	a3,0(a4)
 468:	fd06879b          	addiw	a5,a3,-48
 46c:	0ff7f793          	zext.b	a5,a5
 470:	fef671e3          	bgeu	a2,a5,452 <atoi+0x1c>
  return n;
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret
  n = 0;
 47a:	4501                	li	a0,0
 47c:	bfe5                	j	474 <atoi+0x3e>

000000000000047e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47e:	1141                	addi	sp,sp,-16
 480:	e422                	sd	s0,8(sp)
 482:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 484:	02b57463          	bgeu	a0,a1,4ac <memmove+0x2e>
    while(n-- > 0)
 488:	00c05f63          	blez	a2,4a6 <memmove+0x28>
 48c:	1602                	slli	a2,a2,0x20
 48e:	9201                	srli	a2,a2,0x20
 490:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 494:	872a                	mv	a4,a0
      *dst++ = *src++;
 496:	0585                	addi	a1,a1,1
 498:	0705                	addi	a4,a4,1
 49a:	fff5c683          	lbu	a3,-1(a1)
 49e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4a2:	fef71ae3          	bne	a4,a5,496 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4a6:	6422                	ld	s0,8(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret
    dst += n;
 4ac:	00c50733          	add	a4,a0,a2
    src += n;
 4b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4b2:	fec05ae3          	blez	a2,4a6 <memmove+0x28>
 4b6:	fff6079b          	addiw	a5,a2,-1
 4ba:	1782                	slli	a5,a5,0x20
 4bc:	9381                	srli	a5,a5,0x20
 4be:	fff7c793          	not	a5,a5
 4c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4c4:	15fd                	addi	a1,a1,-1
 4c6:	177d                	addi	a4,a4,-1
 4c8:	0005c683          	lbu	a3,0(a1)
 4cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4d0:	fee79ae3          	bne	a5,a4,4c4 <memmove+0x46>
 4d4:	bfc9                	j	4a6 <memmove+0x28>

00000000000004d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4d6:	1141                	addi	sp,sp,-16
 4d8:	e422                	sd	s0,8(sp)
 4da:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4dc:	ca05                	beqz	a2,50c <memcmp+0x36>
 4de:	fff6069b          	addiw	a3,a2,-1
 4e2:	1682                	slli	a3,a3,0x20
 4e4:	9281                	srli	a3,a3,0x20
 4e6:	0685                	addi	a3,a3,1
 4e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ea:	00054783          	lbu	a5,0(a0)
 4ee:	0005c703          	lbu	a4,0(a1)
 4f2:	00e79863          	bne	a5,a4,502 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4f6:	0505                	addi	a0,a0,1
    p2++;
 4f8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4fa:	fed518e3          	bne	a0,a3,4ea <memcmp+0x14>
  }
  return 0;
 4fe:	4501                	li	a0,0
 500:	a019                	j	506 <memcmp+0x30>
      return *p1 - *p2;
 502:	40e7853b          	subw	a0,a5,a4
}
 506:	6422                	ld	s0,8(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret
  return 0;
 50c:	4501                	li	a0,0
 50e:	bfe5                	j	506 <memcmp+0x30>

0000000000000510 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 510:	1141                	addi	sp,sp,-16
 512:	e406                	sd	ra,8(sp)
 514:	e022                	sd	s0,0(sp)
 516:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 518:	00000097          	auipc	ra,0x0
 51c:	f66080e7          	jalr	-154(ra) # 47e <memmove>
}
 520:	60a2                	ld	ra,8(sp)
 522:	6402                	ld	s0,0(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret

0000000000000528 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 528:	4885                	li	a7,1
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <exit>:
.global exit
exit:
 li a7, SYS_exit
 530:	4889                	li	a7,2
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <wait>:
.global wait
wait:
 li a7, SYS_wait
 538:	488d                	li	a7,3
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 540:	4891                	li	a7,4
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <read>:
.global read
read:
 li a7, SYS_read
 548:	4895                	li	a7,5
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <write>:
.global write
write:
 li a7, SYS_write
 550:	48c1                	li	a7,16
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <close>:
.global close
close:
 li a7, SYS_close
 558:	48d5                	li	a7,21
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <kill>:
.global kill
kill:
 li a7, SYS_kill
 560:	4899                	li	a7,6
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <exec>:
.global exec
exec:
 li a7, SYS_exec
 568:	489d                	li	a7,7
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <open>:
.global open
open:
 li a7, SYS_open
 570:	48bd                	li	a7,15
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 578:	48c5                	li	a7,17
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 580:	48c9                	li	a7,18
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 588:	48a1                	li	a7,8
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <link>:
.global link
link:
 li a7, SYS_link
 590:	48cd                	li	a7,19
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 598:	48d1                	li	a7,20
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a0:	48a5                	li	a7,9
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5a8:	48a9                	li	a7,10
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b0:	48ad                	li	a7,11
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5b8:	48b1                	li	a7,12
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5c0:	48b5                	li	a7,13
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5c8:	48b9                	li	a7,14
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <yield>:
.global yield
yield:
 li a7, SYS_yield
 5d0:	48d9                	li	a7,22
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <lock>:
.global lock
lock:
 li a7, SYS_lock
 5d8:	48dd                	li	a7,23
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 5e0:	48e1                	li	a7,24
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e8:	1101                	addi	sp,sp,-32
 5ea:	ec06                	sd	ra,24(sp)
 5ec:	e822                	sd	s0,16(sp)
 5ee:	1000                	addi	s0,sp,32
 5f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f4:	4605                	li	a2,1
 5f6:	fef40593          	addi	a1,s0,-17
 5fa:	00000097          	auipc	ra,0x0
 5fe:	f56080e7          	jalr	-170(ra) # 550 <write>
}
 602:	60e2                	ld	ra,24(sp)
 604:	6442                	ld	s0,16(sp)
 606:	6105                	addi	sp,sp,32
 608:	8082                	ret

000000000000060a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 60a:	7139                	addi	sp,sp,-64
 60c:	fc06                	sd	ra,56(sp)
 60e:	f822                	sd	s0,48(sp)
 610:	f426                	sd	s1,40(sp)
 612:	0080                	addi	s0,sp,64
 614:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 616:	c299                	beqz	a3,61c <printint+0x12>
 618:	0805cb63          	bltz	a1,6ae <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 61c:	2581                	sext.w	a1,a1
  neg = 0;
 61e:	4881                	li	a7,0
 620:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 624:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 626:	2601                	sext.w	a2,a2
 628:	00000517          	auipc	a0,0x0
 62c:	65050513          	addi	a0,a0,1616 # c78 <digits>
 630:	883a                	mv	a6,a4
 632:	2705                	addiw	a4,a4,1
 634:	02c5f7bb          	remuw	a5,a1,a2
 638:	1782                	slli	a5,a5,0x20
 63a:	9381                	srli	a5,a5,0x20
 63c:	97aa                	add	a5,a5,a0
 63e:	0007c783          	lbu	a5,0(a5)
 642:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 646:	0005879b          	sext.w	a5,a1
 64a:	02c5d5bb          	divuw	a1,a1,a2
 64e:	0685                	addi	a3,a3,1
 650:	fec7f0e3          	bgeu	a5,a2,630 <printint+0x26>
  if(neg)
 654:	00088c63          	beqz	a7,66c <printint+0x62>
    buf[i++] = '-';
 658:	fd070793          	addi	a5,a4,-48
 65c:	00878733          	add	a4,a5,s0
 660:	02d00793          	li	a5,45
 664:	fef70823          	sb	a5,-16(a4)
 668:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 66c:	02e05c63          	blez	a4,6a4 <printint+0x9a>
 670:	f04a                	sd	s2,32(sp)
 672:	ec4e                	sd	s3,24(sp)
 674:	fc040793          	addi	a5,s0,-64
 678:	00e78933          	add	s2,a5,a4
 67c:	fff78993          	addi	s3,a5,-1
 680:	99ba                	add	s3,s3,a4
 682:	377d                	addiw	a4,a4,-1
 684:	1702                	slli	a4,a4,0x20
 686:	9301                	srli	a4,a4,0x20
 688:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 68c:	fff94583          	lbu	a1,-1(s2)
 690:	8526                	mv	a0,s1
 692:	00000097          	auipc	ra,0x0
 696:	f56080e7          	jalr	-170(ra) # 5e8 <putc>
  while(--i >= 0)
 69a:	197d                	addi	s2,s2,-1
 69c:	ff3918e3          	bne	s2,s3,68c <printint+0x82>
 6a0:	7902                	ld	s2,32(sp)
 6a2:	69e2                	ld	s3,24(sp)
}
 6a4:	70e2                	ld	ra,56(sp)
 6a6:	7442                	ld	s0,48(sp)
 6a8:	74a2                	ld	s1,40(sp)
 6aa:	6121                	addi	sp,sp,64
 6ac:	8082                	ret
    x = -xx;
 6ae:	40b005bb          	negw	a1,a1
    neg = 1;
 6b2:	4885                	li	a7,1
    x = -xx;
 6b4:	b7b5                	j	620 <printint+0x16>

00000000000006b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6b6:	715d                	addi	sp,sp,-80
 6b8:	e486                	sd	ra,72(sp)
 6ba:	e0a2                	sd	s0,64(sp)
 6bc:	f84a                	sd	s2,48(sp)
 6be:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6c0:	0005c903          	lbu	s2,0(a1)
 6c4:	1a090a63          	beqz	s2,878 <vprintf+0x1c2>
 6c8:	fc26                	sd	s1,56(sp)
 6ca:	f44e                	sd	s3,40(sp)
 6cc:	f052                	sd	s4,32(sp)
 6ce:	ec56                	sd	s5,24(sp)
 6d0:	e85a                	sd	s6,16(sp)
 6d2:	e45e                	sd	s7,8(sp)
 6d4:	8aaa                	mv	s5,a0
 6d6:	8bb2                	mv	s7,a2
 6d8:	00158493          	addi	s1,a1,1
  state = 0;
 6dc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6de:	02500a13          	li	s4,37
 6e2:	4b55                	li	s6,21
 6e4:	a839                	j	702 <vprintf+0x4c>
        putc(fd, c);
 6e6:	85ca                	mv	a1,s2
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	efe080e7          	jalr	-258(ra) # 5e8 <putc>
 6f2:	a019                	j	6f8 <vprintf+0x42>
    } else if(state == '%'){
 6f4:	01498d63          	beq	s3,s4,70e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 6f8:	0485                	addi	s1,s1,1
 6fa:	fff4c903          	lbu	s2,-1(s1)
 6fe:	16090763          	beqz	s2,86c <vprintf+0x1b6>
    if(state == 0){
 702:	fe0999e3          	bnez	s3,6f4 <vprintf+0x3e>
      if(c == '%'){
 706:	ff4910e3          	bne	s2,s4,6e6 <vprintf+0x30>
        state = '%';
 70a:	89d2                	mv	s3,s4
 70c:	b7f5                	j	6f8 <vprintf+0x42>
      if(c == 'd'){
 70e:	13490463          	beq	s2,s4,836 <vprintf+0x180>
 712:	f9d9079b          	addiw	a5,s2,-99
 716:	0ff7f793          	zext.b	a5,a5
 71a:	12fb6763          	bltu	s6,a5,848 <vprintf+0x192>
 71e:	f9d9079b          	addiw	a5,s2,-99
 722:	0ff7f713          	zext.b	a4,a5
 726:	12eb6163          	bltu	s6,a4,848 <vprintf+0x192>
 72a:	00271793          	slli	a5,a4,0x2
 72e:	00000717          	auipc	a4,0x0
 732:	4f270713          	addi	a4,a4,1266 # c20 <malloc+0x182>
 736:	97ba                	add	a5,a5,a4
 738:	439c                	lw	a5,0(a5)
 73a:	97ba                	add	a5,a5,a4
 73c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 73e:	008b8913          	addi	s2,s7,8
 742:	4685                	li	a3,1
 744:	4629                	li	a2,10
 746:	000ba583          	lw	a1,0(s7)
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	ebe080e7          	jalr	-322(ra) # 60a <printint>
 754:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 756:	4981                	li	s3,0
 758:	b745                	j	6f8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75a:	008b8913          	addi	s2,s7,8
 75e:	4681                	li	a3,0
 760:	4629                	li	a2,10
 762:	000ba583          	lw	a1,0(s7)
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	ea2080e7          	jalr	-350(ra) # 60a <printint>
 770:	8bca                	mv	s7,s2
      state = 0;
 772:	4981                	li	s3,0
 774:	b751                	j	6f8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 776:	008b8913          	addi	s2,s7,8
 77a:	4681                	li	a3,0
 77c:	4641                	li	a2,16
 77e:	000ba583          	lw	a1,0(s7)
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	e86080e7          	jalr	-378(ra) # 60a <printint>
 78c:	8bca                	mv	s7,s2
      state = 0;
 78e:	4981                	li	s3,0
 790:	b7a5                	j	6f8 <vprintf+0x42>
 792:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 794:	008b8c13          	addi	s8,s7,8
 798:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 79c:	03000593          	li	a1,48
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	e46080e7          	jalr	-442(ra) # 5e8 <putc>
  putc(fd, 'x');
 7aa:	07800593          	li	a1,120
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	e38080e7          	jalr	-456(ra) # 5e8 <putc>
 7b8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ba:	00000b97          	auipc	s7,0x0
 7be:	4beb8b93          	addi	s7,s7,1214 # c78 <digits>
 7c2:	03c9d793          	srli	a5,s3,0x3c
 7c6:	97de                	add	a5,a5,s7
 7c8:	0007c583          	lbu	a1,0(a5)
 7cc:	8556                	mv	a0,s5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	e1a080e7          	jalr	-486(ra) # 5e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d6:	0992                	slli	s3,s3,0x4
 7d8:	397d                	addiw	s2,s2,-1
 7da:	fe0914e3          	bnez	s2,7c2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7de:	8be2                	mv	s7,s8
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	6c02                	ld	s8,0(sp)
 7e4:	bf11                	j	6f8 <vprintf+0x42>
        s = va_arg(ap, char*);
 7e6:	008b8993          	addi	s3,s7,8
 7ea:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7ee:	02090163          	beqz	s2,810 <vprintf+0x15a>
        while(*s != 0){
 7f2:	00094583          	lbu	a1,0(s2)
 7f6:	c9a5                	beqz	a1,866 <vprintf+0x1b0>
          putc(fd, *s);
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	dee080e7          	jalr	-530(ra) # 5e8 <putc>
          s++;
 802:	0905                	addi	s2,s2,1
        while(*s != 0){
 804:	00094583          	lbu	a1,0(s2)
 808:	f9e5                	bnez	a1,7f8 <vprintf+0x142>
        s = va_arg(ap, char*);
 80a:	8bce                	mv	s7,s3
      state = 0;
 80c:	4981                	li	s3,0
 80e:	b5ed                	j	6f8 <vprintf+0x42>
          s = "(null)";
 810:	00000917          	auipc	s2,0x0
 814:	40890913          	addi	s2,s2,1032 # c18 <malloc+0x17a>
        while(*s != 0){
 818:	02800593          	li	a1,40
 81c:	bff1                	j	7f8 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 81e:	008b8913          	addi	s2,s7,8
 822:	000bc583          	lbu	a1,0(s7)
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	dc0080e7          	jalr	-576(ra) # 5e8 <putc>
 830:	8bca                	mv	s7,s2
      state = 0;
 832:	4981                	li	s3,0
 834:	b5d1                	j	6f8 <vprintf+0x42>
        putc(fd, c);
 836:	02500593          	li	a1,37
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	dac080e7          	jalr	-596(ra) # 5e8 <putc>
      state = 0;
 844:	4981                	li	s3,0
 846:	bd4d                	j	6f8 <vprintf+0x42>
        putc(fd, '%');
 848:	02500593          	li	a1,37
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	d9a080e7          	jalr	-614(ra) # 5e8 <putc>
        putc(fd, c);
 856:	85ca                	mv	a1,s2
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	d8e080e7          	jalr	-626(ra) # 5e8 <putc>
      state = 0;
 862:	4981                	li	s3,0
 864:	bd51                	j	6f8 <vprintf+0x42>
        s = va_arg(ap, char*);
 866:	8bce                	mv	s7,s3
      state = 0;
 868:	4981                	li	s3,0
 86a:	b579                	j	6f8 <vprintf+0x42>
 86c:	74e2                	ld	s1,56(sp)
 86e:	79a2                	ld	s3,40(sp)
 870:	7a02                	ld	s4,32(sp)
 872:	6ae2                	ld	s5,24(sp)
 874:	6b42                	ld	s6,16(sp)
 876:	6ba2                	ld	s7,8(sp)
    }
  }
}
 878:	60a6                	ld	ra,72(sp)
 87a:	6406                	ld	s0,64(sp)
 87c:	7942                	ld	s2,48(sp)
 87e:	6161                	addi	sp,sp,80
 880:	8082                	ret

0000000000000882 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 882:	715d                	addi	sp,sp,-80
 884:	ec06                	sd	ra,24(sp)
 886:	e822                	sd	s0,16(sp)
 888:	1000                	addi	s0,sp,32
 88a:	e010                	sd	a2,0(s0)
 88c:	e414                	sd	a3,8(s0)
 88e:	e818                	sd	a4,16(s0)
 890:	ec1c                	sd	a5,24(s0)
 892:	03043023          	sd	a6,32(s0)
 896:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 89a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 89e:	8622                	mv	a2,s0
 8a0:	00000097          	auipc	ra,0x0
 8a4:	e16080e7          	jalr	-490(ra) # 6b6 <vprintf>
}
 8a8:	60e2                	ld	ra,24(sp)
 8aa:	6442                	ld	s0,16(sp)
 8ac:	6161                	addi	sp,sp,80
 8ae:	8082                	ret

00000000000008b0 <printf>:

void
printf(const char *fmt, ...)
{
 8b0:	7159                	addi	sp,sp,-112
 8b2:	f406                	sd	ra,40(sp)
 8b4:	f022                	sd	s0,32(sp)
 8b6:	ec26                	sd	s1,24(sp)
 8b8:	1800                	addi	s0,sp,48
 8ba:	84aa                	mv	s1,a0
 8bc:	e40c                	sd	a1,8(s0)
 8be:	e810                	sd	a2,16(s0)
 8c0:	ec14                	sd	a3,24(s0)
 8c2:	f018                	sd	a4,32(s0)
 8c4:	f41c                	sd	a5,40(s0)
 8c6:	03043823          	sd	a6,48(s0)
 8ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 8ce:	00000097          	auipc	ra,0x0
 8d2:	d0a080e7          	jalr	-758(ra) # 5d8 <lock>
  va_start(ap, fmt);
 8d6:	00840613          	addi	a2,s0,8
 8da:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 8de:	85a6                	mv	a1,s1
 8e0:	4505                	li	a0,1
 8e2:	00000097          	auipc	ra,0x0
 8e6:	dd4080e7          	jalr	-556(ra) # 6b6 <vprintf>
  unlock();
 8ea:	00000097          	auipc	ra,0x0
 8ee:	cf6080e7          	jalr	-778(ra) # 5e0 <unlock>
}
 8f2:	70a2                	ld	ra,40(sp)
 8f4:	7402                	ld	s0,32(sp)
 8f6:	64e2                	ld	s1,24(sp)
 8f8:	6165                	addi	sp,sp,112
 8fa:	8082                	ret

00000000000008fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fc:	7179                	addi	sp,sp,-48
 8fe:	f422                	sd	s0,40(sp)
 900:	1800                	addi	s0,sp,48
 902:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 906:	fd843783          	ld	a5,-40(s0)
 90a:	17c1                	addi	a5,a5,-16
 90c:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 910:	00001797          	auipc	a5,0x1
 914:	fa078793          	addi	a5,a5,-96 # 18b0 <freep>
 918:	639c                	ld	a5,0(a5)
 91a:	fef43423          	sd	a5,-24(s0)
 91e:	a815                	j	952 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 920:	fe843783          	ld	a5,-24(s0)
 924:	639c                	ld	a5,0(a5)
 926:	fe843703          	ld	a4,-24(s0)
 92a:	00f76f63          	bltu	a4,a5,948 <free+0x4c>
 92e:	fe043703          	ld	a4,-32(s0)
 932:	fe843783          	ld	a5,-24(s0)
 936:	02e7eb63          	bltu	a5,a4,96c <free+0x70>
 93a:	fe843783          	ld	a5,-24(s0)
 93e:	639c                	ld	a5,0(a5)
 940:	fe043703          	ld	a4,-32(s0)
 944:	02f76463          	bltu	a4,a5,96c <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 948:	fe843783          	ld	a5,-24(s0)
 94c:	639c                	ld	a5,0(a5)
 94e:	fef43423          	sd	a5,-24(s0)
 952:	fe043703          	ld	a4,-32(s0)
 956:	fe843783          	ld	a5,-24(s0)
 95a:	fce7f3e3          	bgeu	a5,a4,920 <free+0x24>
 95e:	fe843783          	ld	a5,-24(s0)
 962:	639c                	ld	a5,0(a5)
 964:	fe043703          	ld	a4,-32(s0)
 968:	faf77ce3          	bgeu	a4,a5,920 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 96c:	fe043783          	ld	a5,-32(s0)
 970:	479c                	lw	a5,8(a5)
 972:	1782                	slli	a5,a5,0x20
 974:	9381                	srli	a5,a5,0x20
 976:	0792                	slli	a5,a5,0x4
 978:	fe043703          	ld	a4,-32(s0)
 97c:	973e                	add	a4,a4,a5
 97e:	fe843783          	ld	a5,-24(s0)
 982:	639c                	ld	a5,0(a5)
 984:	02f71763          	bne	a4,a5,9b2 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 988:	fe043783          	ld	a5,-32(s0)
 98c:	4798                	lw	a4,8(a5)
 98e:	fe843783          	ld	a5,-24(s0)
 992:	639c                	ld	a5,0(a5)
 994:	479c                	lw	a5,8(a5)
 996:	9fb9                	addw	a5,a5,a4
 998:	0007871b          	sext.w	a4,a5
 99c:	fe043783          	ld	a5,-32(s0)
 9a0:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a2:	fe843783          	ld	a5,-24(s0)
 9a6:	639c                	ld	a5,0(a5)
 9a8:	6398                	ld	a4,0(a5)
 9aa:	fe043783          	ld	a5,-32(s0)
 9ae:	e398                	sd	a4,0(a5)
 9b0:	a039                	j	9be <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 9b2:	fe843783          	ld	a5,-24(s0)
 9b6:	6398                	ld	a4,0(a5)
 9b8:	fe043783          	ld	a5,-32(s0)
 9bc:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 9be:	fe843783          	ld	a5,-24(s0)
 9c2:	479c                	lw	a5,8(a5)
 9c4:	1782                	slli	a5,a5,0x20
 9c6:	9381                	srli	a5,a5,0x20
 9c8:	0792                	slli	a5,a5,0x4
 9ca:	fe843703          	ld	a4,-24(s0)
 9ce:	97ba                	add	a5,a5,a4
 9d0:	fe043703          	ld	a4,-32(s0)
 9d4:	02f71563          	bne	a4,a5,9fe <free+0x102>
    p->s.size += bp->s.size;
 9d8:	fe843783          	ld	a5,-24(s0)
 9dc:	4798                	lw	a4,8(a5)
 9de:	fe043783          	ld	a5,-32(s0)
 9e2:	479c                	lw	a5,8(a5)
 9e4:	9fb9                	addw	a5,a5,a4
 9e6:	0007871b          	sext.w	a4,a5
 9ea:	fe843783          	ld	a5,-24(s0)
 9ee:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9f0:	fe043783          	ld	a5,-32(s0)
 9f4:	6398                	ld	a4,0(a5)
 9f6:	fe843783          	ld	a5,-24(s0)
 9fa:	e398                	sd	a4,0(a5)
 9fc:	a031                	j	a08 <free+0x10c>
  } else
    p->s.ptr = bp;
 9fe:	fe843783          	ld	a5,-24(s0)
 a02:	fe043703          	ld	a4,-32(s0)
 a06:	e398                	sd	a4,0(a5)
  freep = p;
 a08:	00001797          	auipc	a5,0x1
 a0c:	ea878793          	addi	a5,a5,-344 # 18b0 <freep>
 a10:	fe843703          	ld	a4,-24(s0)
 a14:	e398                	sd	a4,0(a5)
}
 a16:	0001                	nop
 a18:	7422                	ld	s0,40(sp)
 a1a:	6145                	addi	sp,sp,48
 a1c:	8082                	ret

0000000000000a1e <morecore>:

static Header*
morecore(uint nu)
{
 a1e:	7179                	addi	sp,sp,-48
 a20:	f406                	sd	ra,40(sp)
 a22:	f022                	sd	s0,32(sp)
 a24:	1800                	addi	s0,sp,48
 a26:	87aa                	mv	a5,a0
 a28:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 a2c:	fdc42783          	lw	a5,-36(s0)
 a30:	0007871b          	sext.w	a4,a5
 a34:	6785                	lui	a5,0x1
 a36:	00f77563          	bgeu	a4,a5,a40 <morecore+0x22>
    nu = 4096;
 a3a:	6785                	lui	a5,0x1
 a3c:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 a40:	fdc42783          	lw	a5,-36(s0)
 a44:	0047979b          	slliw	a5,a5,0x4
 a48:	2781                	sext.w	a5,a5
 a4a:	2781                	sext.w	a5,a5
 a4c:	853e                	mv	a0,a5
 a4e:	00000097          	auipc	ra,0x0
 a52:	b6a080e7          	jalr	-1174(ra) # 5b8 <sbrk>
 a56:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 a5a:	fe843703          	ld	a4,-24(s0)
 a5e:	57fd                	li	a5,-1
 a60:	00f71463          	bne	a4,a5,a68 <morecore+0x4a>
    return 0;
 a64:	4781                	li	a5,0
 a66:	a03d                	j	a94 <morecore+0x76>
  hp = (Header*)p;
 a68:	fe843783          	ld	a5,-24(s0)
 a6c:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 a70:	fe043783          	ld	a5,-32(s0)
 a74:	fdc42703          	lw	a4,-36(s0)
 a78:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 a7a:	fe043783          	ld	a5,-32(s0)
 a7e:	07c1                	addi	a5,a5,16 # 1010 <digits+0x398>
 a80:	853e                	mv	a0,a5
 a82:	00000097          	auipc	ra,0x0
 a86:	e7a080e7          	jalr	-390(ra) # 8fc <free>
  return freep;
 a8a:	00001797          	auipc	a5,0x1
 a8e:	e2678793          	addi	a5,a5,-474 # 18b0 <freep>
 a92:	639c                	ld	a5,0(a5)
}
 a94:	853e                	mv	a0,a5
 a96:	70a2                	ld	ra,40(sp)
 a98:	7402                	ld	s0,32(sp)
 a9a:	6145                	addi	sp,sp,48
 a9c:	8082                	ret

0000000000000a9e <malloc>:

void*
malloc(uint nbytes)
{
 a9e:	7139                	addi	sp,sp,-64
 aa0:	fc06                	sd	ra,56(sp)
 aa2:	f822                	sd	s0,48(sp)
 aa4:	0080                	addi	s0,sp,64
 aa6:	87aa                	mv	a5,a0
 aa8:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aac:	fcc46783          	lwu	a5,-52(s0)
 ab0:	07bd                	addi	a5,a5,15
 ab2:	8391                	srli	a5,a5,0x4
 ab4:	2781                	sext.w	a5,a5
 ab6:	2785                	addiw	a5,a5,1
 ab8:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 abc:	00001797          	auipc	a5,0x1
 ac0:	df478793          	addi	a5,a5,-524 # 18b0 <freep>
 ac4:	639c                	ld	a5,0(a5)
 ac6:	fef43023          	sd	a5,-32(s0)
 aca:	fe043783          	ld	a5,-32(s0)
 ace:	ef95                	bnez	a5,b0a <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 ad0:	00001797          	auipc	a5,0x1
 ad4:	dd078793          	addi	a5,a5,-560 # 18a0 <base>
 ad8:	fef43023          	sd	a5,-32(s0)
 adc:	00001797          	auipc	a5,0x1
 ae0:	dd478793          	addi	a5,a5,-556 # 18b0 <freep>
 ae4:	fe043703          	ld	a4,-32(s0)
 ae8:	e398                	sd	a4,0(a5)
 aea:	00001797          	auipc	a5,0x1
 aee:	dc678793          	addi	a5,a5,-570 # 18b0 <freep>
 af2:	6398                	ld	a4,0(a5)
 af4:	00001797          	auipc	a5,0x1
 af8:	dac78793          	addi	a5,a5,-596 # 18a0 <base>
 afc:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 afe:	00001797          	auipc	a5,0x1
 b02:	da278793          	addi	a5,a5,-606 # 18a0 <base>
 b06:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0a:	fe043783          	ld	a5,-32(s0)
 b0e:	639c                	ld	a5,0(a5)
 b10:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 b14:	fe843783          	ld	a5,-24(s0)
 b18:	4798                	lw	a4,8(a5)
 b1a:	fdc42783          	lw	a5,-36(s0)
 b1e:	2781                	sext.w	a5,a5
 b20:	06f76763          	bltu	a4,a5,b8e <malloc+0xf0>
      if(p->s.size == nunits)
 b24:	fe843783          	ld	a5,-24(s0)
 b28:	4798                	lw	a4,8(a5)
 b2a:	fdc42783          	lw	a5,-36(s0)
 b2e:	2781                	sext.w	a5,a5
 b30:	00e79963          	bne	a5,a4,b42 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 b34:	fe843783          	ld	a5,-24(s0)
 b38:	6398                	ld	a4,0(a5)
 b3a:	fe043783          	ld	a5,-32(s0)
 b3e:	e398                	sd	a4,0(a5)
 b40:	a825                	j	b78 <malloc+0xda>
      else {
        p->s.size -= nunits;
 b42:	fe843783          	ld	a5,-24(s0)
 b46:	479c                	lw	a5,8(a5)
 b48:	fdc42703          	lw	a4,-36(s0)
 b4c:	9f99                	subw	a5,a5,a4
 b4e:	0007871b          	sext.w	a4,a5
 b52:	fe843783          	ld	a5,-24(s0)
 b56:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b58:	fe843783          	ld	a5,-24(s0)
 b5c:	479c                	lw	a5,8(a5)
 b5e:	1782                	slli	a5,a5,0x20
 b60:	9381                	srli	a5,a5,0x20
 b62:	0792                	slli	a5,a5,0x4
 b64:	fe843703          	ld	a4,-24(s0)
 b68:	97ba                	add	a5,a5,a4
 b6a:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 b6e:	fe843783          	ld	a5,-24(s0)
 b72:	fdc42703          	lw	a4,-36(s0)
 b76:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 b78:	00001797          	auipc	a5,0x1
 b7c:	d3878793          	addi	a5,a5,-712 # 18b0 <freep>
 b80:	fe043703          	ld	a4,-32(s0)
 b84:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 b86:	fe843783          	ld	a5,-24(s0)
 b8a:	07c1                	addi	a5,a5,16
 b8c:	a091                	j	bd0 <malloc+0x132>
    }
    if(p == freep)
 b8e:	00001797          	auipc	a5,0x1
 b92:	d2278793          	addi	a5,a5,-734 # 18b0 <freep>
 b96:	639c                	ld	a5,0(a5)
 b98:	fe843703          	ld	a4,-24(s0)
 b9c:	02f71063          	bne	a4,a5,bbc <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 ba0:	fdc42783          	lw	a5,-36(s0)
 ba4:	853e                	mv	a0,a5
 ba6:	00000097          	auipc	ra,0x0
 baa:	e78080e7          	jalr	-392(ra) # a1e <morecore>
 bae:	fea43423          	sd	a0,-24(s0)
 bb2:	fe843783          	ld	a5,-24(s0)
 bb6:	e399                	bnez	a5,bbc <malloc+0x11e>
        return 0;
 bb8:	4781                	li	a5,0
 bba:	a819                	j	bd0 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bbc:	fe843783          	ld	a5,-24(s0)
 bc0:	fef43023          	sd	a5,-32(s0)
 bc4:	fe843783          	ld	a5,-24(s0)
 bc8:	639c                	ld	a5,0(a5)
 bca:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 bce:	b799                	j	b14 <malloc+0x76>
  }
}
 bd0:	853e                	mv	a0,a5
 bd2:	70e2                	ld	ra,56(sp)
 bd4:	7442                	ld	s0,48(sp)
 bd6:	6121                	addi	sp,sp,64
 bd8:	8082                	ret
