
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	a2250513          	addi	a0,a0,-1502 # a30 <malloc+0x144>
  16:	00000097          	auipc	ra,0x0
  1a:	3a8080e7          	jalr	936(ra) # 3be <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3d2080e7          	jalr	978(ra) # 3f6 <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3c8080e7          	jalr	968(ra) # 3f6 <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	a0290913          	addi	s2,s2,-1534 # a38 <malloc+0x14c>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6be080e7          	jalr	1726(ra) # 6fe <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	32e080e7          	jalr	814(ra) # 376 <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	32c080e7          	jalr	812(ra) # 386 <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	a1e50513          	addi	a0,a0,-1506 # a88 <malloc+0x19c>
  72:	00000097          	auipc	ra,0x0
  76:	68c080e7          	jalr	1676(ra) # 6fe <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	302080e7          	jalr	770(ra) # 37e <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	9a850513          	addi	a0,a0,-1624 # a30 <malloc+0x144>
  90:	00000097          	auipc	ra,0x0
  94:	336080e7          	jalr	822(ra) # 3c6 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	99650513          	addi	a0,a0,-1642 # a30 <malloc+0x144>
  a2:	00000097          	auipc	ra,0x0
  a6:	31c080e7          	jalr	796(ra) # 3be <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	9a450513          	addi	a0,a0,-1628 # a50 <malloc+0x164>
  b4:	00000097          	auipc	ra,0x0
  b8:	64a080e7          	jalr	1610(ra) # 6fe <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2c0080e7          	jalr	704(ra) # 37e <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	2ea58593          	addi	a1,a1,746 # 13b0 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	99a50513          	addi	a0,a0,-1638 # a68 <malloc+0x17c>
  d6:	00000097          	auipc	ra,0x0
  da:	2e0080e7          	jalr	736(ra) # 3b6 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	99250513          	addi	a0,a0,-1646 # a70 <malloc+0x184>
  e6:	00000097          	auipc	ra,0x0
  ea:	618080e7          	jalr	1560(ra) # 6fe <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	28e080e7          	jalr	654(ra) # 37e <exit>

00000000000000f8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  extern int main();
  main();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <main>
  exit(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	274080e7          	jalr	628(ra) # 37e <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 118:	87aa                	mv	a5,a0
 11a:	0585                	addi	a1,a1,1
 11c:	0785                	addi	a5,a5,1
 11e:	fff5c703          	lbu	a4,-1(a1)
 122:	fee78fa3          	sb	a4,-1(a5)
 126:	fb75                	bnez	a4,11a <strcpy+0x8>
    ;
  return os;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb91                	beqz	a5,14c <strcmp+0x1e>
 13a:	0005c703          	lbu	a4,0(a1)
 13e:	00f71763          	bne	a4,a5,14c <strcmp+0x1e>
    p++, q++;
 142:	0505                	addi	a0,a0,1
 144:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbe5                	bnez	a5,13a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14c:	0005c503          	lbu	a0,0(a1)
}
 150:	40a7853b          	subw	a0,a5,a0
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strlen>:

uint
strlen(const char *s)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x26>
 166:	0505                	addi	a0,a0,1
 168:	87aa                	mv	a5,a0
 16a:	86be                	mv	a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x10>
 174:	40a6853b          	subw	a0,a3,a0
 178:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strlen+0x20>

0000000000000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18a:	ca19                	beqz	a2,1a0 <memset+0x1c>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	slli	a2,a2,0x20
 190:	9201                	srli	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x12>
  }
  return dst;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb99                	beqz	a5,1c6 <strchr+0x20>
    if(*s == c)
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1a>
  for(; *s; s++)
 1b6:	0505                	addi	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xc>
      return (char*)s;
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <strchr+0x1a>

00000000000001ca <gets>:

char*
gets(char *buf, int max)
{
 1ca:	711d                	addi	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	1080                	addi	s0,sp,96
 1e0:	8baa                	mv	s7,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e8:	4aa9                	li	s5,10
 1ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ec:	89a6                	mv	s3,s1
 1ee:	2485                	addiw	s1,s1,1
 1f0:	0344d863          	bge	s1,s4,220 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	4605                	li	a2,1
 1f6:	faf40593          	addi	a1,s0,-81
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	19a080e7          	jalr	410(ra) # 396 <read>
    if(cc < 1)
 204:	00a05e63          	blez	a0,220 <gets+0x56>
    buf[i++] = c;
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 210:	01578763          	beq	a5,s5,21e <gets+0x54>
 214:	0905                	addi	s2,s2,1
 216:	fd679be3          	bne	a5,s6,1ec <gets+0x22>
    buf[i++] = c;
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x56>
 21e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
  return buf;
}
 226:	855e                	mv	a0,s7
 228:	60e6                	ld	ra,88(sp)
 22a:	6446                	ld	s0,80(sp)
 22c:	64a6                	ld	s1,72(sp)
 22e:	6906                	ld	s2,64(sp)
 230:	79e2                	ld	s3,56(sp)
 232:	7a42                	ld	s4,48(sp)
 234:	7aa2                	ld	s5,40(sp)
 236:	7b02                	ld	s6,32(sp)
 238:	6be2                	ld	s7,24(sp)
 23a:	6125                	addi	sp,sp,96
 23c:	8082                	ret

000000000000023e <stat>:

int
stat(const char *n, struct stat *st)
{
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e04a                	sd	s2,0(sp)
 246:	1000                	addi	s0,sp,32
 248:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24a:	4581                	li	a1,0
 24c:	00000097          	auipc	ra,0x0
 250:	172080e7          	jalr	370(ra) # 3be <open>
  if(fd < 0)
 254:	02054663          	bltz	a0,280 <stat+0x42>
 258:	e426                	sd	s1,8(sp)
 25a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25c:	85ca                	mv	a1,s2
 25e:	00000097          	auipc	ra,0x0
 262:	178080e7          	jalr	376(ra) # 3d6 <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	00000097          	auipc	ra,0x0
 26e:	13c080e7          	jalr	316(ra) # 3a6 <close>
  return r;
 272:	64a2                	ld	s1,8(sp)
}
 274:	854a                	mv	a0,s2
 276:	60e2                	ld	ra,24(sp)
 278:	6442                	ld	s0,16(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfcd                	j	274 <stat+0x36>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66863          	bltu	a2,a5,2c8 <atoi+0x44>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a0:	0705                	addi	a4,a4,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1c>
  return n;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  n = 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <atoi+0x3e>

00000000000002cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d2:	02b57463          	bgeu	a0,a1,2fa <memmove+0x2e>
    while(n-- > 0)
 2d6:	00c05f63          	blez	a2,2f4 <memmove+0x28>
 2da:	1602                	slli	a2,a2,0x20
 2dc:	9201                	srli	a2,a2,0x20
 2de:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e4:	0585                	addi	a1,a1,1
 2e6:	0705                	addi	a4,a4,1
 2e8:	fff5c683          	lbu	a3,-1(a1)
 2ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f0:	fef71ae3          	bne	a4,a5,2e4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
    dst += n;
 2fa:	00c50733          	add	a4,a0,a2
    src += n;
 2fe:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 300:	fec05ae3          	blez	a2,2f4 <memmove+0x28>
 304:	fff6079b          	addiw	a5,a2,-1
 308:	1782                	slli	a5,a5,0x20
 30a:	9381                	srli	a5,a5,0x20
 30c:	fff7c793          	not	a5,a5
 310:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 312:	15fd                	addi	a1,a1,-1
 314:	177d                	addi	a4,a4,-1
 316:	0005c683          	lbu	a3,0(a1)
 31a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31e:	fee79ae3          	bne	a5,a4,312 <memmove+0x46>
 322:	bfc9                	j	2f4 <memmove+0x28>

0000000000000324 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32a:	ca05                	beqz	a2,35a <memcmp+0x36>
 32c:	fff6069b          	addiw	a3,a2,-1
 330:	1682                	slli	a3,a3,0x20
 332:	9281                	srli	a3,a3,0x20
 334:	0685                	addi	a3,a3,1
 336:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 338:	00054783          	lbu	a5,0(a0)
 33c:	0005c703          	lbu	a4,0(a1)
 340:	00e79863          	bne	a5,a4,350 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 344:	0505                	addi	a0,a0,1
    p2++;
 346:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 348:	fed518e3          	bne	a0,a3,338 <memcmp+0x14>
  }
  return 0;
 34c:	4501                	li	a0,0
 34e:	a019                	j	354 <memcmp+0x30>
      return *p1 - *p2;
 350:	40e7853b          	subw	a0,a5,a4
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
  return 0;
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <memcmp+0x30>

000000000000035e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 366:	00000097          	auipc	ra,0x0
 36a:	f66080e7          	jalr	-154(ra) # 2cc <memmove>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 376:	4885                	li	a7,1
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <exit>:
.global exit
exit:
 li a7, SYS_exit
 37e:	4889                	li	a7,2
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <wait>:
.global wait
wait:
 li a7, SYS_wait
 386:	488d                	li	a7,3
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38e:	4891                	li	a7,4
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <read>:
.global read
read:
 li a7, SYS_read
 396:	4895                	li	a7,5
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <write>:
.global write
write:
 li a7, SYS_write
 39e:	48c1                	li	a7,16
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <close>:
.global close
close:
 li a7, SYS_close
 3a6:	48d5                	li	a7,21
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ae:	4899                	li	a7,6
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b6:	489d                	li	a7,7
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <open>:
.global open
open:
 li a7, SYS_open
 3be:	48bd                	li	a7,15
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c6:	48c5                	li	a7,17
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ce:	48c9                	li	a7,18
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d6:	48a1                	li	a7,8
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <link>:
.global link
link:
 li a7, SYS_link
 3de:	48cd                	li	a7,19
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e6:	48d1                	li	a7,20
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ee:	48a5                	li	a7,9
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f6:	48a9                	li	a7,10
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fe:	48ad                	li	a7,11
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 406:	48b1                	li	a7,12
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 40e:	48b5                	li	a7,13
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 416:	48b9                	li	a7,14
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <yield>:
.global yield
yield:
 li a7, SYS_yield
 41e:	48d9                	li	a7,22
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <lock>:
.global lock
lock:
 li a7, SYS_lock
 426:	48dd                	li	a7,23
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 42e:	48e1                	li	a7,24
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 436:	1101                	addi	sp,sp,-32
 438:	ec06                	sd	ra,24(sp)
 43a:	e822                	sd	s0,16(sp)
 43c:	1000                	addi	s0,sp,32
 43e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 442:	4605                	li	a2,1
 444:	fef40593          	addi	a1,s0,-17
 448:	00000097          	auipc	ra,0x0
 44c:	f56080e7          	jalr	-170(ra) # 39e <write>
}
 450:	60e2                	ld	ra,24(sp)
 452:	6442                	ld	s0,16(sp)
 454:	6105                	addi	sp,sp,32
 456:	8082                	ret

0000000000000458 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 458:	7139                	addi	sp,sp,-64
 45a:	fc06                	sd	ra,56(sp)
 45c:	f822                	sd	s0,48(sp)
 45e:	f426                	sd	s1,40(sp)
 460:	0080                	addi	s0,sp,64
 462:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 464:	c299                	beqz	a3,46a <printint+0x12>
 466:	0805cb63          	bltz	a1,4fc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 46a:	2581                	sext.w	a1,a1
  neg = 0;
 46c:	4881                	li	a7,0
 46e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 472:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 474:	2601                	sext.w	a2,a2
 476:	00000517          	auipc	a0,0x0
 47a:	69250513          	addi	a0,a0,1682 # b08 <digits>
 47e:	883a                	mv	a6,a4
 480:	2705                	addiw	a4,a4,1
 482:	02c5f7bb          	remuw	a5,a1,a2
 486:	1782                	slli	a5,a5,0x20
 488:	9381                	srli	a5,a5,0x20
 48a:	97aa                	add	a5,a5,a0
 48c:	0007c783          	lbu	a5,0(a5)
 490:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 494:	0005879b          	sext.w	a5,a1
 498:	02c5d5bb          	divuw	a1,a1,a2
 49c:	0685                	addi	a3,a3,1
 49e:	fec7f0e3          	bgeu	a5,a2,47e <printint+0x26>
  if(neg)
 4a2:	00088c63          	beqz	a7,4ba <printint+0x62>
    buf[i++] = '-';
 4a6:	fd070793          	addi	a5,a4,-48
 4aa:	00878733          	add	a4,a5,s0
 4ae:	02d00793          	li	a5,45
 4b2:	fef70823          	sb	a5,-16(a4)
 4b6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ba:	02e05c63          	blez	a4,4f2 <printint+0x9a>
 4be:	f04a                	sd	s2,32(sp)
 4c0:	ec4e                	sd	s3,24(sp)
 4c2:	fc040793          	addi	a5,s0,-64
 4c6:	00e78933          	add	s2,a5,a4
 4ca:	fff78993          	addi	s3,a5,-1
 4ce:	99ba                	add	s3,s3,a4
 4d0:	377d                	addiw	a4,a4,-1
 4d2:	1702                	slli	a4,a4,0x20
 4d4:	9301                	srli	a4,a4,0x20
 4d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4da:	fff94583          	lbu	a1,-1(s2)
 4de:	8526                	mv	a0,s1
 4e0:	00000097          	auipc	ra,0x0
 4e4:	f56080e7          	jalr	-170(ra) # 436 <putc>
  while(--i >= 0)
 4e8:	197d                	addi	s2,s2,-1
 4ea:	ff3918e3          	bne	s2,s3,4da <printint+0x82>
 4ee:	7902                	ld	s2,32(sp)
 4f0:	69e2                	ld	s3,24(sp)
}
 4f2:	70e2                	ld	ra,56(sp)
 4f4:	7442                	ld	s0,48(sp)
 4f6:	74a2                	ld	s1,40(sp)
 4f8:	6121                	addi	sp,sp,64
 4fa:	8082                	ret
    x = -xx;
 4fc:	40b005bb          	negw	a1,a1
    neg = 1;
 500:	4885                	li	a7,1
    x = -xx;
 502:	b7b5                	j	46e <printint+0x16>

0000000000000504 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 504:	715d                	addi	sp,sp,-80
 506:	e486                	sd	ra,72(sp)
 508:	e0a2                	sd	s0,64(sp)
 50a:	f84a                	sd	s2,48(sp)
 50c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 50e:	0005c903          	lbu	s2,0(a1)
 512:	1a090a63          	beqz	s2,6c6 <vprintf+0x1c2>
 516:	fc26                	sd	s1,56(sp)
 518:	f44e                	sd	s3,40(sp)
 51a:	f052                	sd	s4,32(sp)
 51c:	ec56                	sd	s5,24(sp)
 51e:	e85a                	sd	s6,16(sp)
 520:	e45e                	sd	s7,8(sp)
 522:	8aaa                	mv	s5,a0
 524:	8bb2                	mv	s7,a2
 526:	00158493          	addi	s1,a1,1
  state = 0;
 52a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 52c:	02500a13          	li	s4,37
 530:	4b55                	li	s6,21
 532:	a839                	j	550 <vprintf+0x4c>
        putc(fd, c);
 534:	85ca                	mv	a1,s2
 536:	8556                	mv	a0,s5
 538:	00000097          	auipc	ra,0x0
 53c:	efe080e7          	jalr	-258(ra) # 436 <putc>
 540:	a019                	j	546 <vprintf+0x42>
    } else if(state == '%'){
 542:	01498d63          	beq	s3,s4,55c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 546:	0485                	addi	s1,s1,1
 548:	fff4c903          	lbu	s2,-1(s1)
 54c:	16090763          	beqz	s2,6ba <vprintf+0x1b6>
    if(state == 0){
 550:	fe0999e3          	bnez	s3,542 <vprintf+0x3e>
      if(c == '%'){
 554:	ff4910e3          	bne	s2,s4,534 <vprintf+0x30>
        state = '%';
 558:	89d2                	mv	s3,s4
 55a:	b7f5                	j	546 <vprintf+0x42>
      if(c == 'd'){
 55c:	13490463          	beq	s2,s4,684 <vprintf+0x180>
 560:	f9d9079b          	addiw	a5,s2,-99
 564:	0ff7f793          	zext.b	a5,a5
 568:	12fb6763          	bltu	s6,a5,696 <vprintf+0x192>
 56c:	f9d9079b          	addiw	a5,s2,-99
 570:	0ff7f713          	zext.b	a4,a5
 574:	12eb6163          	bltu	s6,a4,696 <vprintf+0x192>
 578:	00271793          	slli	a5,a4,0x2
 57c:	00000717          	auipc	a4,0x0
 580:	53470713          	addi	a4,a4,1332 # ab0 <malloc+0x1c4>
 584:	97ba                	add	a5,a5,a4
 586:	439c                	lw	a5,0(a5)
 588:	97ba                	add	a5,a5,a4
 58a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 58c:	008b8913          	addi	s2,s7,8
 590:	4685                	li	a3,1
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	ebe080e7          	jalr	-322(ra) # 458 <printint>
 5a2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b745                	j	546 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4629                	li	a2,10
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	ea2080e7          	jalr	-350(ra) # 458 <printint>
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b751                	j	546 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4641                	li	a2,16
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e86080e7          	jalr	-378(ra) # 458 <printint>
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b7a5                	j	546 <vprintf+0x42>
 5e0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5e2:	008b8c13          	addi	s8,s7,8
 5e6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ea:	03000593          	li	a1,48
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e46080e7          	jalr	-442(ra) # 436 <putc>
  putc(fd, 'x');
 5f8:	07800593          	li	a1,120
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e38080e7          	jalr	-456(ra) # 436 <putc>
 606:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 608:	00000b97          	auipc	s7,0x0
 60c:	500b8b93          	addi	s7,s7,1280 # b08 <digits>
 610:	03c9d793          	srli	a5,s3,0x3c
 614:	97de                	add	a5,a5,s7
 616:	0007c583          	lbu	a1,0(a5)
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	e1a080e7          	jalr	-486(ra) # 436 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 624:	0992                	slli	s3,s3,0x4
 626:	397d                	addiw	s2,s2,-1
 628:	fe0914e3          	bnez	s2,610 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 62c:	8be2                	mv	s7,s8
      state = 0;
 62e:	4981                	li	s3,0
 630:	6c02                	ld	s8,0(sp)
 632:	bf11                	j	546 <vprintf+0x42>
        s = va_arg(ap, char*);
 634:	008b8993          	addi	s3,s7,8
 638:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 63c:	02090163          	beqz	s2,65e <vprintf+0x15a>
        while(*s != 0){
 640:	00094583          	lbu	a1,0(s2)
 644:	c9a5                	beqz	a1,6b4 <vprintf+0x1b0>
          putc(fd, *s);
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	dee080e7          	jalr	-530(ra) # 436 <putc>
          s++;
 650:	0905                	addi	s2,s2,1
        while(*s != 0){
 652:	00094583          	lbu	a1,0(s2)
 656:	f9e5                	bnez	a1,646 <vprintf+0x142>
        s = va_arg(ap, char*);
 658:	8bce                	mv	s7,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b5ed                	j	546 <vprintf+0x42>
          s = "(null)";
 65e:	00000917          	auipc	s2,0x0
 662:	44a90913          	addi	s2,s2,1098 # aa8 <malloc+0x1bc>
        while(*s != 0){
 666:	02800593          	li	a1,40
 66a:	bff1                	j	646 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 66c:	008b8913          	addi	s2,s7,8
 670:	000bc583          	lbu	a1,0(s7)
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	dc0080e7          	jalr	-576(ra) # 436 <putc>
 67e:	8bca                	mv	s7,s2
      state = 0;
 680:	4981                	li	s3,0
 682:	b5d1                	j	546 <vprintf+0x42>
        putc(fd, c);
 684:	02500593          	li	a1,37
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	dac080e7          	jalr	-596(ra) # 436 <putc>
      state = 0;
 692:	4981                	li	s3,0
 694:	bd4d                	j	546 <vprintf+0x42>
        putc(fd, '%');
 696:	02500593          	li	a1,37
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	d9a080e7          	jalr	-614(ra) # 436 <putc>
        putc(fd, c);
 6a4:	85ca                	mv	a1,s2
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	d8e080e7          	jalr	-626(ra) # 436 <putc>
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bd51                	j	546 <vprintf+0x42>
        s = va_arg(ap, char*);
 6b4:	8bce                	mv	s7,s3
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b579                	j	546 <vprintf+0x42>
 6ba:	74e2                	ld	s1,56(sp)
 6bc:	79a2                	ld	s3,40(sp)
 6be:	7a02                	ld	s4,32(sp)
 6c0:	6ae2                	ld	s5,24(sp)
 6c2:	6b42                	ld	s6,16(sp)
 6c4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6c6:	60a6                	ld	ra,72(sp)
 6c8:	6406                	ld	s0,64(sp)
 6ca:	7942                	ld	s2,48(sp)
 6cc:	6161                	addi	sp,sp,80
 6ce:	8082                	ret

00000000000006d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d0:	715d                	addi	sp,sp,-80
 6d2:	ec06                	sd	ra,24(sp)
 6d4:	e822                	sd	s0,16(sp)
 6d6:	1000                	addi	s0,sp,32
 6d8:	e010                	sd	a2,0(s0)
 6da:	e414                	sd	a3,8(s0)
 6dc:	e818                	sd	a4,16(s0)
 6de:	ec1c                	sd	a5,24(s0)
 6e0:	03043023          	sd	a6,32(s0)
 6e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ec:	8622                	mv	a2,s0
 6ee:	00000097          	auipc	ra,0x0
 6f2:	e16080e7          	jalr	-490(ra) # 504 <vprintf>
}
 6f6:	60e2                	ld	ra,24(sp)
 6f8:	6442                	ld	s0,16(sp)
 6fa:	6161                	addi	sp,sp,80
 6fc:	8082                	ret

00000000000006fe <printf>:

void
printf(const char *fmt, ...)
{
 6fe:	7159                	addi	sp,sp,-112
 700:	f406                	sd	ra,40(sp)
 702:	f022                	sd	s0,32(sp)
 704:	ec26                	sd	s1,24(sp)
 706:	1800                	addi	s0,sp,48
 708:	84aa                	mv	s1,a0
 70a:	e40c                	sd	a1,8(s0)
 70c:	e810                	sd	a2,16(s0)
 70e:	ec14                	sd	a3,24(s0)
 710:	f018                	sd	a4,32(s0)
 712:	f41c                	sd	a5,40(s0)
 714:	03043823          	sd	a6,48(s0)
 718:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 71c:	00000097          	auipc	ra,0x0
 720:	d0a080e7          	jalr	-758(ra) # 426 <lock>
  va_start(ap, fmt);
 724:	00840613          	addi	a2,s0,8
 728:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 72c:	85a6                	mv	a1,s1
 72e:	4505                	li	a0,1
 730:	00000097          	auipc	ra,0x0
 734:	dd4080e7          	jalr	-556(ra) # 504 <vprintf>
  unlock();
 738:	00000097          	auipc	ra,0x0
 73c:	cf6080e7          	jalr	-778(ra) # 42e <unlock>
}
 740:	70a2                	ld	ra,40(sp)
 742:	7402                	ld	s0,32(sp)
 744:	64e2                	ld	s1,24(sp)
 746:	6165                	addi	sp,sp,112
 748:	8082                	ret

000000000000074a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74a:	7179                	addi	sp,sp,-48
 74c:	f422                	sd	s0,40(sp)
 74e:	1800                	addi	s0,sp,48
 750:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	fd843783          	ld	a5,-40(s0)
 758:	17c1                	addi	a5,a5,-16
 75a:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	00001797          	auipc	a5,0x1
 762:	c7278793          	addi	a5,a5,-910 # 13d0 <freep>
 766:	639c                	ld	a5,0(a5)
 768:	fef43423          	sd	a5,-24(s0)
 76c:	a815                	j	7a0 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76e:	fe843783          	ld	a5,-24(s0)
 772:	639c                	ld	a5,0(a5)
 774:	fe843703          	ld	a4,-24(s0)
 778:	00f76f63          	bltu	a4,a5,796 <free+0x4c>
 77c:	fe043703          	ld	a4,-32(s0)
 780:	fe843783          	ld	a5,-24(s0)
 784:	02e7eb63          	bltu	a5,a4,7ba <free+0x70>
 788:	fe843783          	ld	a5,-24(s0)
 78c:	639c                	ld	a5,0(a5)
 78e:	fe043703          	ld	a4,-32(s0)
 792:	02f76463          	bltu	a4,a5,7ba <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 796:	fe843783          	ld	a5,-24(s0)
 79a:	639c                	ld	a5,0(a5)
 79c:	fef43423          	sd	a5,-24(s0)
 7a0:	fe043703          	ld	a4,-32(s0)
 7a4:	fe843783          	ld	a5,-24(s0)
 7a8:	fce7f3e3          	bgeu	a5,a4,76e <free+0x24>
 7ac:	fe843783          	ld	a5,-24(s0)
 7b0:	639c                	ld	a5,0(a5)
 7b2:	fe043703          	ld	a4,-32(s0)
 7b6:	faf77ce3          	bgeu	a4,a5,76e <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ba:	fe043783          	ld	a5,-32(s0)
 7be:	479c                	lw	a5,8(a5)
 7c0:	1782                	slli	a5,a5,0x20
 7c2:	9381                	srli	a5,a5,0x20
 7c4:	0792                	slli	a5,a5,0x4
 7c6:	fe043703          	ld	a4,-32(s0)
 7ca:	973e                	add	a4,a4,a5
 7cc:	fe843783          	ld	a5,-24(s0)
 7d0:	639c                	ld	a5,0(a5)
 7d2:	02f71763          	bne	a4,a5,800 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 7d6:	fe043783          	ld	a5,-32(s0)
 7da:	4798                	lw	a4,8(a5)
 7dc:	fe843783          	ld	a5,-24(s0)
 7e0:	639c                	ld	a5,0(a5)
 7e2:	479c                	lw	a5,8(a5)
 7e4:	9fb9                	addw	a5,a5,a4
 7e6:	0007871b          	sext.w	a4,a5
 7ea:	fe043783          	ld	a5,-32(s0)
 7ee:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f0:	fe843783          	ld	a5,-24(s0)
 7f4:	639c                	ld	a5,0(a5)
 7f6:	6398                	ld	a4,0(a5)
 7f8:	fe043783          	ld	a5,-32(s0)
 7fc:	e398                	sd	a4,0(a5)
 7fe:	a039                	j	80c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 800:	fe843783          	ld	a5,-24(s0)
 804:	6398                	ld	a4,0(a5)
 806:	fe043783          	ld	a5,-32(s0)
 80a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 80c:	fe843783          	ld	a5,-24(s0)
 810:	479c                	lw	a5,8(a5)
 812:	1782                	slli	a5,a5,0x20
 814:	9381                	srli	a5,a5,0x20
 816:	0792                	slli	a5,a5,0x4
 818:	fe843703          	ld	a4,-24(s0)
 81c:	97ba                	add	a5,a5,a4
 81e:	fe043703          	ld	a4,-32(s0)
 822:	02f71563          	bne	a4,a5,84c <free+0x102>
    p->s.size += bp->s.size;
 826:	fe843783          	ld	a5,-24(s0)
 82a:	4798                	lw	a4,8(a5)
 82c:	fe043783          	ld	a5,-32(s0)
 830:	479c                	lw	a5,8(a5)
 832:	9fb9                	addw	a5,a5,a4
 834:	0007871b          	sext.w	a4,a5
 838:	fe843783          	ld	a5,-24(s0)
 83c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83e:	fe043783          	ld	a5,-32(s0)
 842:	6398                	ld	a4,0(a5)
 844:	fe843783          	ld	a5,-24(s0)
 848:	e398                	sd	a4,0(a5)
 84a:	a031                	j	856 <free+0x10c>
  } else
    p->s.ptr = bp;
 84c:	fe843783          	ld	a5,-24(s0)
 850:	fe043703          	ld	a4,-32(s0)
 854:	e398                	sd	a4,0(a5)
  freep = p;
 856:	00001797          	auipc	a5,0x1
 85a:	b7a78793          	addi	a5,a5,-1158 # 13d0 <freep>
 85e:	fe843703          	ld	a4,-24(s0)
 862:	e398                	sd	a4,0(a5)
}
 864:	0001                	nop
 866:	7422                	ld	s0,40(sp)
 868:	6145                	addi	sp,sp,48
 86a:	8082                	ret

000000000000086c <morecore>:

static Header*
morecore(uint nu)
{
 86c:	7179                	addi	sp,sp,-48
 86e:	f406                	sd	ra,40(sp)
 870:	f022                	sd	s0,32(sp)
 872:	1800                	addi	s0,sp,48
 874:	87aa                	mv	a5,a0
 876:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 87a:	fdc42783          	lw	a5,-36(s0)
 87e:	0007871b          	sext.w	a4,a5
 882:	6785                	lui	a5,0x1
 884:	00f77563          	bgeu	a4,a5,88e <morecore+0x22>
    nu = 4096;
 888:	6785                	lui	a5,0x1
 88a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 88e:	fdc42783          	lw	a5,-36(s0)
 892:	0047979b          	slliw	a5,a5,0x4
 896:	2781                	sext.w	a5,a5
 898:	2781                	sext.w	a5,a5
 89a:	853e                	mv	a0,a5
 89c:	00000097          	auipc	ra,0x0
 8a0:	b6a080e7          	jalr	-1174(ra) # 406 <sbrk>
 8a4:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 8a8:	fe843703          	ld	a4,-24(s0)
 8ac:	57fd                	li	a5,-1
 8ae:	00f71463          	bne	a4,a5,8b6 <morecore+0x4a>
    return 0;
 8b2:	4781                	li	a5,0
 8b4:	a03d                	j	8e2 <morecore+0x76>
  hp = (Header*)p;
 8b6:	fe843783          	ld	a5,-24(s0)
 8ba:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 8be:	fe043783          	ld	a5,-32(s0)
 8c2:	fdc42703          	lw	a4,-36(s0)
 8c6:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 8c8:	fe043783          	ld	a5,-32(s0)
 8cc:	07c1                	addi	a5,a5,16 # 1010 <digits+0x508>
 8ce:	853e                	mv	a0,a5
 8d0:	00000097          	auipc	ra,0x0
 8d4:	e7a080e7          	jalr	-390(ra) # 74a <free>
  return freep;
 8d8:	00001797          	auipc	a5,0x1
 8dc:	af878793          	addi	a5,a5,-1288 # 13d0 <freep>
 8e0:	639c                	ld	a5,0(a5)
}
 8e2:	853e                	mv	a0,a5
 8e4:	70a2                	ld	ra,40(sp)
 8e6:	7402                	ld	s0,32(sp)
 8e8:	6145                	addi	sp,sp,48
 8ea:	8082                	ret

00000000000008ec <malloc>:

void*
malloc(uint nbytes)
{
 8ec:	7139                	addi	sp,sp,-64
 8ee:	fc06                	sd	ra,56(sp)
 8f0:	f822                	sd	s0,48(sp)
 8f2:	0080                	addi	s0,sp,64
 8f4:	87aa                	mv	a5,a0
 8f6:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8fa:	fcc46783          	lwu	a5,-52(s0)
 8fe:	07bd                	addi	a5,a5,15
 900:	8391                	srli	a5,a5,0x4
 902:	2781                	sext.w	a5,a5
 904:	2785                	addiw	a5,a5,1
 906:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 90a:	00001797          	auipc	a5,0x1
 90e:	ac678793          	addi	a5,a5,-1338 # 13d0 <freep>
 912:	639c                	ld	a5,0(a5)
 914:	fef43023          	sd	a5,-32(s0)
 918:	fe043783          	ld	a5,-32(s0)
 91c:	ef95                	bnez	a5,958 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 91e:	00001797          	auipc	a5,0x1
 922:	aa278793          	addi	a5,a5,-1374 # 13c0 <base>
 926:	fef43023          	sd	a5,-32(s0)
 92a:	00001797          	auipc	a5,0x1
 92e:	aa678793          	addi	a5,a5,-1370 # 13d0 <freep>
 932:	fe043703          	ld	a4,-32(s0)
 936:	e398                	sd	a4,0(a5)
 938:	00001797          	auipc	a5,0x1
 93c:	a9878793          	addi	a5,a5,-1384 # 13d0 <freep>
 940:	6398                	ld	a4,0(a5)
 942:	00001797          	auipc	a5,0x1
 946:	a7e78793          	addi	a5,a5,-1410 # 13c0 <base>
 94a:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 94c:	00001797          	auipc	a5,0x1
 950:	a7478793          	addi	a5,a5,-1420 # 13c0 <base>
 954:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 958:	fe043783          	ld	a5,-32(s0)
 95c:	639c                	ld	a5,0(a5)
 95e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 962:	fe843783          	ld	a5,-24(s0)
 966:	4798                	lw	a4,8(a5)
 968:	fdc42783          	lw	a5,-36(s0)
 96c:	2781                	sext.w	a5,a5
 96e:	06f76763          	bltu	a4,a5,9dc <malloc+0xf0>
      if(p->s.size == nunits)
 972:	fe843783          	ld	a5,-24(s0)
 976:	4798                	lw	a4,8(a5)
 978:	fdc42783          	lw	a5,-36(s0)
 97c:	2781                	sext.w	a5,a5
 97e:	00e79963          	bne	a5,a4,990 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 982:	fe843783          	ld	a5,-24(s0)
 986:	6398                	ld	a4,0(a5)
 988:	fe043783          	ld	a5,-32(s0)
 98c:	e398                	sd	a4,0(a5)
 98e:	a825                	j	9c6 <malloc+0xda>
      else {
        p->s.size -= nunits;
 990:	fe843783          	ld	a5,-24(s0)
 994:	479c                	lw	a5,8(a5)
 996:	fdc42703          	lw	a4,-36(s0)
 99a:	9f99                	subw	a5,a5,a4
 99c:	0007871b          	sext.w	a4,a5
 9a0:	fe843783          	ld	a5,-24(s0)
 9a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a6:	fe843783          	ld	a5,-24(s0)
 9aa:	479c                	lw	a5,8(a5)
 9ac:	1782                	slli	a5,a5,0x20
 9ae:	9381                	srli	a5,a5,0x20
 9b0:	0792                	slli	a5,a5,0x4
 9b2:	fe843703          	ld	a4,-24(s0)
 9b6:	97ba                	add	a5,a5,a4
 9b8:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 9bc:	fe843783          	ld	a5,-24(s0)
 9c0:	fdc42703          	lw	a4,-36(s0)
 9c4:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 9c6:	00001797          	auipc	a5,0x1
 9ca:	a0a78793          	addi	a5,a5,-1526 # 13d0 <freep>
 9ce:	fe043703          	ld	a4,-32(s0)
 9d2:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 9d4:	fe843783          	ld	a5,-24(s0)
 9d8:	07c1                	addi	a5,a5,16
 9da:	a091                	j	a1e <malloc+0x132>
    }
    if(p == freep)
 9dc:	00001797          	auipc	a5,0x1
 9e0:	9f478793          	addi	a5,a5,-1548 # 13d0 <freep>
 9e4:	639c                	ld	a5,0(a5)
 9e6:	fe843703          	ld	a4,-24(s0)
 9ea:	02f71063          	bne	a4,a5,a0a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 9ee:	fdc42783          	lw	a5,-36(s0)
 9f2:	853e                	mv	a0,a5
 9f4:	00000097          	auipc	ra,0x0
 9f8:	e78080e7          	jalr	-392(ra) # 86c <morecore>
 9fc:	fea43423          	sd	a0,-24(s0)
 a00:	fe843783          	ld	a5,-24(s0)
 a04:	e399                	bnez	a5,a0a <malloc+0x11e>
        return 0;
 a06:	4781                	li	a5,0
 a08:	a819                	j	a1e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0a:	fe843783          	ld	a5,-24(s0)
 a0e:	fef43023          	sd	a5,-32(s0)
 a12:	fe843783          	ld	a5,-24(s0)
 a16:	639c                	ld	a5,0(a5)
 a18:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 a1c:	b799                	j	962 <malloc+0x76>
  }
}
 a1e:	853e                	mv	a0,a5
 a20:	70e2                	ld	ra,56(sp)
 a22:	7442                	ld	s0,48(sp)
 a24:	6121                	addi	sp,sp,64
 a26:	8082                	ret
