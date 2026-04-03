
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	a5a78793          	addi	a5,a5,-1446 # a70 <malloc+0x170>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	a1450513          	addi	a0,a0,-1516 # a40 <malloc+0x140>
  34:	00000097          	auipc	ra,0x0
  38:	6de080e7          	jalr	1758(ra) # 712 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	150080e7          	jalr	336(ra) # 198 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	336080e7          	jalr	822(ra) # 38a <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	9f050513          	addi	a0,a0,-1552 # a58 <malloc+0x158>
  70:	00000097          	auipc	ra,0x0
  74:	6a2080e7          	jalr	1698(ra) # 712 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	348080e7          	jalr	840(ra) # 3d2 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	312080e7          	jalr	786(ra) # 3b2 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	30c080e7          	jalr	780(ra) # 3ba <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	9b250513          	addi	a0,a0,-1614 # a68 <malloc+0x168>
  be:	00000097          	auipc	ra,0x0
  c2:	654080e7          	jalr	1620(ra) # 712 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	306080e7          	jalr	774(ra) # 3d2 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2c8080e7          	jalr	712(ra) # 3aa <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2ca080e7          	jalr	714(ra) # 3ba <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2a0080e7          	jalr	672(ra) # 39a <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	28e080e7          	jalr	654(ra) # 392 <exit>

000000000000010c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  extern int main();
  main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
  exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	274080e7          	jalr	628(ra) # 392 <exit>

0000000000000126 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
    ;
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
    p++, q++;
 156:	0505                	addi	a0,a0,1
 158:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint
strlen(const char *s)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	addi	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	86be                	mv	a3,a5
 180:	0785                	addi	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	ff65                	bnez	a4,17e <strlen+0x10>
 188:	40a6853b          	subw	a0,a3,a0
 18c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  for(n = 0; s[n]; n++)
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <memset>:

void*
memset(void *dst, int c, uint n)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19e:	ca19                	beqz	a2,1b4 <memset+0x1c>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	slli	a2,a2,0x20
 1a4:	9201                	srli	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ae:	0785                	addi	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x12>
  }
  return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char*
strchr(const char *s, char c)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb99                	beqz	a5,1da <strchr+0x20>
    if(*s == c)
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1a>
  for(; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xc>
      return (char*)s;
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strchr+0x1a>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	711d                	addi	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fc:	4aa9                	li	s5,10
 1fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	2485                	addiw	s1,s1,1
 204:	0344d863          	bge	s1,s4,234 <gets+0x56>
    cc = read(0, &c, 1);
 208:	4605                	li	a2,1
 20a:	faf40593          	addi	a1,s0,-81
 20e:	4501                	li	a0,0
 210:	00000097          	auipc	ra,0x0
 214:	19a080e7          	jalr	410(ra) # 3aa <read>
    if(cc < 1)
 218:	00a05e63          	blez	a0,234 <gets+0x56>
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 224:	01578763          	beq	a5,s5,232 <gets+0x54>
 228:	0905                	addi	s2,s2,1
 22a:	fd679be3          	bne	a5,s6,200 <gets+0x22>
    buf[i++] = c;
 22e:	89a6                	mv	s3,s1
 230:	a011                	j	234 <gets+0x56>
 232:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 234:	99de                	add	s3,s3,s7
 236:	00098023          	sb	zero,0(s3)
  return buf;
}
 23a:	855e                	mv	a0,s7
 23c:	60e6                	ld	ra,88(sp)
 23e:	6446                	ld	s0,80(sp)
 240:	64a6                	ld	s1,72(sp)
 242:	6906                	ld	s2,64(sp)
 244:	79e2                	ld	s3,56(sp)
 246:	7a42                	ld	s4,48(sp)
 248:	7aa2                	ld	s5,40(sp)
 24a:	7b02                	ld	s6,32(sp)
 24c:	6be2                	ld	s7,24(sp)
 24e:	6125                	addi	sp,sp,96
 250:	8082                	ret

0000000000000252 <stat>:

int
stat(const char *n, struct stat *st)
{
 252:	1101                	addi	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e04a                	sd	s2,0(sp)
 25a:	1000                	addi	s0,sp,32
 25c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25e:	4581                	li	a1,0
 260:	00000097          	auipc	ra,0x0
 264:	172080e7          	jalr	370(ra) # 3d2 <open>
  if(fd < 0)
 268:	02054663          	bltz	a0,294 <stat+0x42>
 26c:	e426                	sd	s1,8(sp)
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	00000097          	auipc	ra,0x0
 276:	178080e7          	jalr	376(ra) # 3ea <fstat>
 27a:	892a                	mv	s2,a0
  close(fd);
 27c:	8526                	mv	a0,s1
 27e:	00000097          	auipc	ra,0x0
 282:	13c080e7          	jalr	316(ra) # 3ba <close>
  return r;
 286:	64a2                	ld	s1,8(sp)
}
 288:	854a                	mv	a0,s2
 28a:	60e2                	ld	ra,24(sp)
 28c:	6442                	ld	s0,16(sp)
 28e:	6902                	ld	s2,0(sp)
 290:	6105                	addi	sp,sp,32
 292:	8082                	ret
    return -1;
 294:	597d                	li	s2,-1
 296:	bfcd                	j	288 <stat+0x36>

0000000000000298 <atoi>:

int
atoi(const char *s)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29e:	00054683          	lbu	a3,0(a0)
 2a2:	fd06879b          	addiw	a5,a3,-48
 2a6:	0ff7f793          	zext.b	a5,a5
 2aa:	4625                	li	a2,9
 2ac:	02f66863          	bltu	a2,a5,2dc <atoi+0x44>
 2b0:	872a                	mv	a4,a0
  n = 0;
 2b2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b4:	0705                	addi	a4,a4,1
 2b6:	0025179b          	slliw	a5,a0,0x2
 2ba:	9fa9                	addw	a5,a5,a0
 2bc:	0017979b          	slliw	a5,a5,0x1
 2c0:	9fb5                	addw	a5,a5,a3
 2c2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c6:	00074683          	lbu	a3,0(a4)
 2ca:	fd06879b          	addiw	a5,a3,-48
 2ce:	0ff7f793          	zext.b	a5,a5
 2d2:	fef671e3          	bgeu	a2,a5,2b4 <atoi+0x1c>
  return n;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  n = 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <atoi+0x3e>

00000000000002e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57463          	bgeu	a0,a1,30e <memmove+0x2e>
    while(n-- > 0)
 2ea:	00c05f63          	blez	a2,308 <memmove+0x28>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 304:	fef71ae3          	bne	a4,a5,2f8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
    dst += n;
 30e:	00c50733          	add	a4,a0,a2
    src += n;
 312:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 314:	fec05ae3          	blez	a2,308 <memmove+0x28>
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	fff7c793          	not	a5,a5
 324:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 326:	15fd                	addi	a1,a1,-1
 328:	177d                	addi	a4,a4,-1
 32a:	0005c683          	lbu	a3,0(a1)
 32e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 332:	fee79ae3          	bne	a5,a4,326 <memmove+0x46>
 336:	bfc9                	j	308 <memmove+0x28>

0000000000000338 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33e:	ca05                	beqz	a2,36e <memcmp+0x36>
 340:	fff6069b          	addiw	a3,a2,-1
 344:	1682                	slli	a3,a3,0x20
 346:	9281                	srli	a3,a3,0x20
 348:	0685                	addi	a3,a3,1
 34a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34c:	00054783          	lbu	a5,0(a0)
 350:	0005c703          	lbu	a4,0(a1)
 354:	00e79863          	bne	a5,a4,364 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 358:	0505                	addi	a0,a0,1
    p2++;
 35a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35c:	fed518e3          	bne	a0,a3,34c <memcmp+0x14>
  }
  return 0;
 360:	4501                	li	a0,0
 362:	a019                	j	368 <memcmp+0x30>
      return *p1 - *p2;
 364:	40e7853b          	subw	a0,a5,a4
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
  return 0;
 36e:	4501                	li	a0,0
 370:	bfe5                	j	368 <memcmp+0x30>

0000000000000372 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 372:	1141                	addi	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37a:	00000097          	auipc	ra,0x0
 37e:	f66080e7          	jalr	-154(ra) # 2e0 <memmove>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38a:	4885                	li	a7,1
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exit>:
.global exit
exit:
 li a7, SYS_exit
 392:	4889                	li	a7,2
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <wait>:
.global wait
wait:
 li a7, SYS_wait
 39a:	488d                	li	a7,3
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a2:	4891                	li	a7,4
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <read>:
.global read
read:
 li a7, SYS_read
 3aa:	4895                	li	a7,5
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <write>:
.global write
write:
 li a7, SYS_write
 3b2:	48c1                	li	a7,16
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <close>:
.global close
close:
 li a7, SYS_close
 3ba:	48d5                	li	a7,21
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c2:	4899                	li	a7,6
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ca:	489d                	li	a7,7
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <open>:
.global open
open:
 li a7, SYS_open
 3d2:	48bd                	li	a7,15
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3da:	48c5                	li	a7,17
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e2:	48c9                	li	a7,18
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ea:	48a1                	li	a7,8
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <link>:
.global link
link:
 li a7, SYS_link
 3f2:	48cd                	li	a7,19
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fa:	48d1                	li	a7,20
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 402:	48a5                	li	a7,9
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <dup>:
.global dup
dup:
 li a7, SYS_dup
 40a:	48a9                	li	a7,10
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 412:	48ad                	li	a7,11
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41a:	48b1                	li	a7,12
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 422:	48b5                	li	a7,13
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42a:	48b9                	li	a7,14
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <yield>:
.global yield
yield:
 li a7, SYS_yield
 432:	48d9                	li	a7,22
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <lock>:
.global lock
lock:
 li a7, SYS_lock
 43a:	48dd                	li	a7,23
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 442:	48e1                	li	a7,24
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44a:	1101                	addi	sp,sp,-32
 44c:	ec06                	sd	ra,24(sp)
 44e:	e822                	sd	s0,16(sp)
 450:	1000                	addi	s0,sp,32
 452:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 456:	4605                	li	a2,1
 458:	fef40593          	addi	a1,s0,-17
 45c:	00000097          	auipc	ra,0x0
 460:	f56080e7          	jalr	-170(ra) # 3b2 <write>
}
 464:	60e2                	ld	ra,24(sp)
 466:	6442                	ld	s0,16(sp)
 468:	6105                	addi	sp,sp,32
 46a:	8082                	ret

000000000000046c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46c:	7139                	addi	sp,sp,-64
 46e:	fc06                	sd	ra,56(sp)
 470:	f822                	sd	s0,48(sp)
 472:	f426                	sd	s1,40(sp)
 474:	0080                	addi	s0,sp,64
 476:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 478:	c299                	beqz	a3,47e <printint+0x12>
 47a:	0805cb63          	bltz	a1,510 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47e:	2581                	sext.w	a1,a1
  neg = 0;
 480:	4881                	li	a7,0
 482:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 486:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 488:	2601                	sext.w	a2,a2
 48a:	00000517          	auipc	a0,0x0
 48e:	65650513          	addi	a0,a0,1622 # ae0 <digits>
 492:	883a                	mv	a6,a4
 494:	2705                	addiw	a4,a4,1
 496:	02c5f7bb          	remuw	a5,a1,a2
 49a:	1782                	slli	a5,a5,0x20
 49c:	9381                	srli	a5,a5,0x20
 49e:	97aa                	add	a5,a5,a0
 4a0:	0007c783          	lbu	a5,0(a5)
 4a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a8:	0005879b          	sext.w	a5,a1
 4ac:	02c5d5bb          	divuw	a1,a1,a2
 4b0:	0685                	addi	a3,a3,1
 4b2:	fec7f0e3          	bgeu	a5,a2,492 <printint+0x26>
  if(neg)
 4b6:	00088c63          	beqz	a7,4ce <printint+0x62>
    buf[i++] = '-';
 4ba:	fd070793          	addi	a5,a4,-48
 4be:	00878733          	add	a4,a5,s0
 4c2:	02d00793          	li	a5,45
 4c6:	fef70823          	sb	a5,-16(a4)
 4ca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ce:	02e05c63          	blez	a4,506 <printint+0x9a>
 4d2:	f04a                	sd	s2,32(sp)
 4d4:	ec4e                	sd	s3,24(sp)
 4d6:	fc040793          	addi	a5,s0,-64
 4da:	00e78933          	add	s2,a5,a4
 4de:	fff78993          	addi	s3,a5,-1
 4e2:	99ba                	add	s3,s3,a4
 4e4:	377d                	addiw	a4,a4,-1
 4e6:	1702                	slli	a4,a4,0x20
 4e8:	9301                	srli	a4,a4,0x20
 4ea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ee:	fff94583          	lbu	a1,-1(s2)
 4f2:	8526                	mv	a0,s1
 4f4:	00000097          	auipc	ra,0x0
 4f8:	f56080e7          	jalr	-170(ra) # 44a <putc>
  while(--i >= 0)
 4fc:	197d                	addi	s2,s2,-1
 4fe:	ff3918e3          	bne	s2,s3,4ee <printint+0x82>
 502:	7902                	ld	s2,32(sp)
 504:	69e2                	ld	s3,24(sp)
}
 506:	70e2                	ld	ra,56(sp)
 508:	7442                	ld	s0,48(sp)
 50a:	74a2                	ld	s1,40(sp)
 50c:	6121                	addi	sp,sp,64
 50e:	8082                	ret
    x = -xx;
 510:	40b005bb          	negw	a1,a1
    neg = 1;
 514:	4885                	li	a7,1
    x = -xx;
 516:	b7b5                	j	482 <printint+0x16>

0000000000000518 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 518:	715d                	addi	sp,sp,-80
 51a:	e486                	sd	ra,72(sp)
 51c:	e0a2                	sd	s0,64(sp)
 51e:	f84a                	sd	s2,48(sp)
 520:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 522:	0005c903          	lbu	s2,0(a1)
 526:	1a090a63          	beqz	s2,6da <vprintf+0x1c2>
 52a:	fc26                	sd	s1,56(sp)
 52c:	f44e                	sd	s3,40(sp)
 52e:	f052                	sd	s4,32(sp)
 530:	ec56                	sd	s5,24(sp)
 532:	e85a                	sd	s6,16(sp)
 534:	e45e                	sd	s7,8(sp)
 536:	8aaa                	mv	s5,a0
 538:	8bb2                	mv	s7,a2
 53a:	00158493          	addi	s1,a1,1
  state = 0;
 53e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 540:	02500a13          	li	s4,37
 544:	4b55                	li	s6,21
 546:	a839                	j	564 <vprintf+0x4c>
        putc(fd, c);
 548:	85ca                	mv	a1,s2
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	efe080e7          	jalr	-258(ra) # 44a <putc>
 554:	a019                	j	55a <vprintf+0x42>
    } else if(state == '%'){
 556:	01498d63          	beq	s3,s4,570 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 55a:	0485                	addi	s1,s1,1
 55c:	fff4c903          	lbu	s2,-1(s1)
 560:	16090763          	beqz	s2,6ce <vprintf+0x1b6>
    if(state == 0){
 564:	fe0999e3          	bnez	s3,556 <vprintf+0x3e>
      if(c == '%'){
 568:	ff4910e3          	bne	s2,s4,548 <vprintf+0x30>
        state = '%';
 56c:	89d2                	mv	s3,s4
 56e:	b7f5                	j	55a <vprintf+0x42>
      if(c == 'd'){
 570:	13490463          	beq	s2,s4,698 <vprintf+0x180>
 574:	f9d9079b          	addiw	a5,s2,-99
 578:	0ff7f793          	zext.b	a5,a5
 57c:	12fb6763          	bltu	s6,a5,6aa <vprintf+0x192>
 580:	f9d9079b          	addiw	a5,s2,-99
 584:	0ff7f713          	zext.b	a4,a5
 588:	12eb6163          	bltu	s6,a4,6aa <vprintf+0x192>
 58c:	00271793          	slli	a5,a4,0x2
 590:	00000717          	auipc	a4,0x0
 594:	4f870713          	addi	a4,a4,1272 # a88 <malloc+0x188>
 598:	97ba                	add	a5,a5,a4
 59a:	439c                	lw	a5,0(a5)
 59c:	97ba                	add	a5,a5,a4
 59e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	ebe080e7          	jalr	-322(ra) # 46c <printint>
 5b6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b745                	j	55a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	ea2080e7          	jalr	-350(ra) # 46c <printint>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b751                	j	55a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e86080e7          	jalr	-378(ra) # 46c <printint>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b7a5                	j	55a <vprintf+0x42>
 5f4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5f6:	008b8c13          	addi	s8,s7,8
 5fa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fe:	03000593          	li	a1,48
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e46080e7          	jalr	-442(ra) # 44a <putc>
  putc(fd, 'x');
 60c:	07800593          	li	a1,120
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	e38080e7          	jalr	-456(ra) # 44a <putc>
 61a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61c:	00000b97          	auipc	s7,0x0
 620:	4c4b8b93          	addi	s7,s7,1220 # ae0 <digits>
 624:	03c9d793          	srli	a5,s3,0x3c
 628:	97de                	add	a5,a5,s7
 62a:	0007c583          	lbu	a1,0(a5)
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	e1a080e7          	jalr	-486(ra) # 44a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 638:	0992                	slli	s3,s3,0x4
 63a:	397d                	addiw	s2,s2,-1
 63c:	fe0914e3          	bnez	s2,624 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 640:	8be2                	mv	s7,s8
      state = 0;
 642:	4981                	li	s3,0
 644:	6c02                	ld	s8,0(sp)
 646:	bf11                	j	55a <vprintf+0x42>
        s = va_arg(ap, char*);
 648:	008b8993          	addi	s3,s7,8
 64c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 650:	02090163          	beqz	s2,672 <vprintf+0x15a>
        while(*s != 0){
 654:	00094583          	lbu	a1,0(s2)
 658:	c9a5                	beqz	a1,6c8 <vprintf+0x1b0>
          putc(fd, *s);
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	dee080e7          	jalr	-530(ra) # 44a <putc>
          s++;
 664:	0905                	addi	s2,s2,1
        while(*s != 0){
 666:	00094583          	lbu	a1,0(s2)
 66a:	f9e5                	bnez	a1,65a <vprintf+0x142>
        s = va_arg(ap, char*);
 66c:	8bce                	mv	s7,s3
      state = 0;
 66e:	4981                	li	s3,0
 670:	b5ed                	j	55a <vprintf+0x42>
          s = "(null)";
 672:	00000917          	auipc	s2,0x0
 676:	40e90913          	addi	s2,s2,1038 # a80 <malloc+0x180>
        while(*s != 0){
 67a:	02800593          	li	a1,40
 67e:	bff1                	j	65a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 680:	008b8913          	addi	s2,s7,8
 684:	000bc583          	lbu	a1,0(s7)
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	dc0080e7          	jalr	-576(ra) # 44a <putc>
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
 696:	b5d1                	j	55a <vprintf+0x42>
        putc(fd, c);
 698:	02500593          	li	a1,37
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	dac080e7          	jalr	-596(ra) # 44a <putc>
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bd4d                	j	55a <vprintf+0x42>
        putc(fd, '%');
 6aa:	02500593          	li	a1,37
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	d9a080e7          	jalr	-614(ra) # 44a <putc>
        putc(fd, c);
 6b8:	85ca                	mv	a1,s2
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	d8e080e7          	jalr	-626(ra) # 44a <putc>
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bd51                	j	55a <vprintf+0x42>
        s = va_arg(ap, char*);
 6c8:	8bce                	mv	s7,s3
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b579                	j	55a <vprintf+0x42>
 6ce:	74e2                	ld	s1,56(sp)
 6d0:	79a2                	ld	s3,40(sp)
 6d2:	7a02                	ld	s4,32(sp)
 6d4:	6ae2                	ld	s5,24(sp)
 6d6:	6b42                	ld	s6,16(sp)
 6d8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6da:	60a6                	ld	ra,72(sp)
 6dc:	6406                	ld	s0,64(sp)
 6de:	7942                	ld	s2,48(sp)
 6e0:	6161                	addi	sp,sp,80
 6e2:	8082                	ret

00000000000006e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e4:	715d                	addi	sp,sp,-80
 6e6:	ec06                	sd	ra,24(sp)
 6e8:	e822                	sd	s0,16(sp)
 6ea:	1000                	addi	s0,sp,32
 6ec:	e010                	sd	a2,0(s0)
 6ee:	e414                	sd	a3,8(s0)
 6f0:	e818                	sd	a4,16(s0)
 6f2:	ec1c                	sd	a5,24(s0)
 6f4:	03043023          	sd	a6,32(s0)
 6f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 700:	8622                	mv	a2,s0
 702:	00000097          	auipc	ra,0x0
 706:	e16080e7          	jalr	-490(ra) # 518 <vprintf>
}
 70a:	60e2                	ld	ra,24(sp)
 70c:	6442                	ld	s0,16(sp)
 70e:	6161                	addi	sp,sp,80
 710:	8082                	ret

0000000000000712 <printf>:

void
printf(const char *fmt, ...)
{
 712:	7159                	addi	sp,sp,-112
 714:	f406                	sd	ra,40(sp)
 716:	f022                	sd	s0,32(sp)
 718:	ec26                	sd	s1,24(sp)
 71a:	1800                	addi	s0,sp,48
 71c:	84aa                	mv	s1,a0
 71e:	e40c                	sd	a1,8(s0)
 720:	e810                	sd	a2,16(s0)
 722:	ec14                	sd	a3,24(s0)
 724:	f018                	sd	a4,32(s0)
 726:	f41c                	sd	a5,40(s0)
 728:	03043823          	sd	a6,48(s0)
 72c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 730:	00000097          	auipc	ra,0x0
 734:	d0a080e7          	jalr	-758(ra) # 43a <lock>
  va_start(ap, fmt);
 738:	00840613          	addi	a2,s0,8
 73c:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 740:	85a6                	mv	a1,s1
 742:	4505                	li	a0,1
 744:	00000097          	auipc	ra,0x0
 748:	dd4080e7          	jalr	-556(ra) # 518 <vprintf>
  unlock();
 74c:	00000097          	auipc	ra,0x0
 750:	cf6080e7          	jalr	-778(ra) # 442 <unlock>
}
 754:	70a2                	ld	ra,40(sp)
 756:	7402                	ld	s0,32(sp)
 758:	64e2                	ld	s1,24(sp)
 75a:	6165                	addi	sp,sp,112
 75c:	8082                	ret

000000000000075e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75e:	7179                	addi	sp,sp,-48
 760:	f422                	sd	s0,40(sp)
 762:	1800                	addi	s0,sp,48
 764:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 768:	fd843783          	ld	a5,-40(s0)
 76c:	17c1                	addi	a5,a5,-16
 76e:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	00001797          	auipc	a5,0x1
 776:	c4e78793          	addi	a5,a5,-946 # 13c0 <freep>
 77a:	639c                	ld	a5,0(a5)
 77c:	fef43423          	sd	a5,-24(s0)
 780:	a815                	j	7b4 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 782:	fe843783          	ld	a5,-24(s0)
 786:	639c                	ld	a5,0(a5)
 788:	fe843703          	ld	a4,-24(s0)
 78c:	00f76f63          	bltu	a4,a5,7aa <free+0x4c>
 790:	fe043703          	ld	a4,-32(s0)
 794:	fe843783          	ld	a5,-24(s0)
 798:	02e7eb63          	bltu	a5,a4,7ce <free+0x70>
 79c:	fe843783          	ld	a5,-24(s0)
 7a0:	639c                	ld	a5,0(a5)
 7a2:	fe043703          	ld	a4,-32(s0)
 7a6:	02f76463          	bltu	a4,a5,7ce <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	fe843783          	ld	a5,-24(s0)
 7ae:	639c                	ld	a5,0(a5)
 7b0:	fef43423          	sd	a5,-24(s0)
 7b4:	fe043703          	ld	a4,-32(s0)
 7b8:	fe843783          	ld	a5,-24(s0)
 7bc:	fce7f3e3          	bgeu	a5,a4,782 <free+0x24>
 7c0:	fe843783          	ld	a5,-24(s0)
 7c4:	639c                	ld	a5,0(a5)
 7c6:	fe043703          	ld	a4,-32(s0)
 7ca:	faf77ce3          	bgeu	a4,a5,782 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ce:	fe043783          	ld	a5,-32(s0)
 7d2:	479c                	lw	a5,8(a5)
 7d4:	1782                	slli	a5,a5,0x20
 7d6:	9381                	srli	a5,a5,0x20
 7d8:	0792                	slli	a5,a5,0x4
 7da:	fe043703          	ld	a4,-32(s0)
 7de:	973e                	add	a4,a4,a5
 7e0:	fe843783          	ld	a5,-24(s0)
 7e4:	639c                	ld	a5,0(a5)
 7e6:	02f71763          	bne	a4,a5,814 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 7ea:	fe043783          	ld	a5,-32(s0)
 7ee:	4798                	lw	a4,8(a5)
 7f0:	fe843783          	ld	a5,-24(s0)
 7f4:	639c                	ld	a5,0(a5)
 7f6:	479c                	lw	a5,8(a5)
 7f8:	9fb9                	addw	a5,a5,a4
 7fa:	0007871b          	sext.w	a4,a5
 7fe:	fe043783          	ld	a5,-32(s0)
 802:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 804:	fe843783          	ld	a5,-24(s0)
 808:	639c                	ld	a5,0(a5)
 80a:	6398                	ld	a4,0(a5)
 80c:	fe043783          	ld	a5,-32(s0)
 810:	e398                	sd	a4,0(a5)
 812:	a039                	j	820 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 814:	fe843783          	ld	a5,-24(s0)
 818:	6398                	ld	a4,0(a5)
 81a:	fe043783          	ld	a5,-32(s0)
 81e:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 820:	fe843783          	ld	a5,-24(s0)
 824:	479c                	lw	a5,8(a5)
 826:	1782                	slli	a5,a5,0x20
 828:	9381                	srli	a5,a5,0x20
 82a:	0792                	slli	a5,a5,0x4
 82c:	fe843703          	ld	a4,-24(s0)
 830:	97ba                	add	a5,a5,a4
 832:	fe043703          	ld	a4,-32(s0)
 836:	02f71563          	bne	a4,a5,860 <free+0x102>
    p->s.size += bp->s.size;
 83a:	fe843783          	ld	a5,-24(s0)
 83e:	4798                	lw	a4,8(a5)
 840:	fe043783          	ld	a5,-32(s0)
 844:	479c                	lw	a5,8(a5)
 846:	9fb9                	addw	a5,a5,a4
 848:	0007871b          	sext.w	a4,a5
 84c:	fe843783          	ld	a5,-24(s0)
 850:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 852:	fe043783          	ld	a5,-32(s0)
 856:	6398                	ld	a4,0(a5)
 858:	fe843783          	ld	a5,-24(s0)
 85c:	e398                	sd	a4,0(a5)
 85e:	a031                	j	86a <free+0x10c>
  } else
    p->s.ptr = bp;
 860:	fe843783          	ld	a5,-24(s0)
 864:	fe043703          	ld	a4,-32(s0)
 868:	e398                	sd	a4,0(a5)
  freep = p;
 86a:	00001797          	auipc	a5,0x1
 86e:	b5678793          	addi	a5,a5,-1194 # 13c0 <freep>
 872:	fe843703          	ld	a4,-24(s0)
 876:	e398                	sd	a4,0(a5)
}
 878:	0001                	nop
 87a:	7422                	ld	s0,40(sp)
 87c:	6145                	addi	sp,sp,48
 87e:	8082                	ret

0000000000000880 <morecore>:

static Header*
morecore(uint nu)
{
 880:	7179                	addi	sp,sp,-48
 882:	f406                	sd	ra,40(sp)
 884:	f022                	sd	s0,32(sp)
 886:	1800                	addi	s0,sp,48
 888:	87aa                	mv	a5,a0
 88a:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 88e:	fdc42783          	lw	a5,-36(s0)
 892:	0007871b          	sext.w	a4,a5
 896:	6785                	lui	a5,0x1
 898:	00f77563          	bgeu	a4,a5,8a2 <morecore+0x22>
    nu = 4096;
 89c:	6785                	lui	a5,0x1
 89e:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 8a2:	fdc42783          	lw	a5,-36(s0)
 8a6:	0047979b          	slliw	a5,a5,0x4
 8aa:	2781                	sext.w	a5,a5
 8ac:	2781                	sext.w	a5,a5
 8ae:	853e                	mv	a0,a5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	b6a080e7          	jalr	-1174(ra) # 41a <sbrk>
 8b8:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 8bc:	fe843703          	ld	a4,-24(s0)
 8c0:	57fd                	li	a5,-1
 8c2:	00f71463          	bne	a4,a5,8ca <morecore+0x4a>
    return 0;
 8c6:	4781                	li	a5,0
 8c8:	a03d                	j	8f6 <morecore+0x76>
  hp = (Header*)p;
 8ca:	fe843783          	ld	a5,-24(s0)
 8ce:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 8d2:	fe043783          	ld	a5,-32(s0)
 8d6:	fdc42703          	lw	a4,-36(s0)
 8da:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 8dc:	fe043783          	ld	a5,-32(s0)
 8e0:	07c1                	addi	a5,a5,16 # 1010 <digits+0x530>
 8e2:	853e                	mv	a0,a5
 8e4:	00000097          	auipc	ra,0x0
 8e8:	e7a080e7          	jalr	-390(ra) # 75e <free>
  return freep;
 8ec:	00001797          	auipc	a5,0x1
 8f0:	ad478793          	addi	a5,a5,-1324 # 13c0 <freep>
 8f4:	639c                	ld	a5,0(a5)
}
 8f6:	853e                	mv	a0,a5
 8f8:	70a2                	ld	ra,40(sp)
 8fa:	7402                	ld	s0,32(sp)
 8fc:	6145                	addi	sp,sp,48
 8fe:	8082                	ret

0000000000000900 <malloc>:

void*
malloc(uint nbytes)
{
 900:	7139                	addi	sp,sp,-64
 902:	fc06                	sd	ra,56(sp)
 904:	f822                	sd	s0,48(sp)
 906:	0080                	addi	s0,sp,64
 908:	87aa                	mv	a5,a0
 90a:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90e:	fcc46783          	lwu	a5,-52(s0)
 912:	07bd                	addi	a5,a5,15
 914:	8391                	srli	a5,a5,0x4
 916:	2781                	sext.w	a5,a5
 918:	2785                	addiw	a5,a5,1
 91a:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 91e:	00001797          	auipc	a5,0x1
 922:	aa278793          	addi	a5,a5,-1374 # 13c0 <freep>
 926:	639c                	ld	a5,0(a5)
 928:	fef43023          	sd	a5,-32(s0)
 92c:	fe043783          	ld	a5,-32(s0)
 930:	ef95                	bnez	a5,96c <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 932:	00001797          	auipc	a5,0x1
 936:	a7e78793          	addi	a5,a5,-1410 # 13b0 <base>
 93a:	fef43023          	sd	a5,-32(s0)
 93e:	00001797          	auipc	a5,0x1
 942:	a8278793          	addi	a5,a5,-1406 # 13c0 <freep>
 946:	fe043703          	ld	a4,-32(s0)
 94a:	e398                	sd	a4,0(a5)
 94c:	00001797          	auipc	a5,0x1
 950:	a7478793          	addi	a5,a5,-1420 # 13c0 <freep>
 954:	6398                	ld	a4,0(a5)
 956:	00001797          	auipc	a5,0x1
 95a:	a5a78793          	addi	a5,a5,-1446 # 13b0 <base>
 95e:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 960:	00001797          	auipc	a5,0x1
 964:	a5078793          	addi	a5,a5,-1456 # 13b0 <base>
 968:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96c:	fe043783          	ld	a5,-32(s0)
 970:	639c                	ld	a5,0(a5)
 972:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 976:	fe843783          	ld	a5,-24(s0)
 97a:	4798                	lw	a4,8(a5)
 97c:	fdc42783          	lw	a5,-36(s0)
 980:	2781                	sext.w	a5,a5
 982:	06f76763          	bltu	a4,a5,9f0 <malloc+0xf0>
      if(p->s.size == nunits)
 986:	fe843783          	ld	a5,-24(s0)
 98a:	4798                	lw	a4,8(a5)
 98c:	fdc42783          	lw	a5,-36(s0)
 990:	2781                	sext.w	a5,a5
 992:	00e79963          	bne	a5,a4,9a4 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 996:	fe843783          	ld	a5,-24(s0)
 99a:	6398                	ld	a4,0(a5)
 99c:	fe043783          	ld	a5,-32(s0)
 9a0:	e398                	sd	a4,0(a5)
 9a2:	a825                	j	9da <malloc+0xda>
      else {
        p->s.size -= nunits;
 9a4:	fe843783          	ld	a5,-24(s0)
 9a8:	479c                	lw	a5,8(a5)
 9aa:	fdc42703          	lw	a4,-36(s0)
 9ae:	9f99                	subw	a5,a5,a4
 9b0:	0007871b          	sext.w	a4,a5
 9b4:	fe843783          	ld	a5,-24(s0)
 9b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ba:	fe843783          	ld	a5,-24(s0)
 9be:	479c                	lw	a5,8(a5)
 9c0:	1782                	slli	a5,a5,0x20
 9c2:	9381                	srli	a5,a5,0x20
 9c4:	0792                	slli	a5,a5,0x4
 9c6:	fe843703          	ld	a4,-24(s0)
 9ca:	97ba                	add	a5,a5,a4
 9cc:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 9d0:	fe843783          	ld	a5,-24(s0)
 9d4:	fdc42703          	lw	a4,-36(s0)
 9d8:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 9da:	00001797          	auipc	a5,0x1
 9de:	9e678793          	addi	a5,a5,-1562 # 13c0 <freep>
 9e2:	fe043703          	ld	a4,-32(s0)
 9e6:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 9e8:	fe843783          	ld	a5,-24(s0)
 9ec:	07c1                	addi	a5,a5,16
 9ee:	a091                	j	a32 <malloc+0x132>
    }
    if(p == freep)
 9f0:	00001797          	auipc	a5,0x1
 9f4:	9d078793          	addi	a5,a5,-1584 # 13c0 <freep>
 9f8:	639c                	ld	a5,0(a5)
 9fa:	fe843703          	ld	a4,-24(s0)
 9fe:	02f71063          	bne	a4,a5,a1e <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 a02:	fdc42783          	lw	a5,-36(s0)
 a06:	853e                	mv	a0,a5
 a08:	00000097          	auipc	ra,0x0
 a0c:	e78080e7          	jalr	-392(ra) # 880 <morecore>
 a10:	fea43423          	sd	a0,-24(s0)
 a14:	fe843783          	ld	a5,-24(s0)
 a18:	e399                	bnez	a5,a1e <malloc+0x11e>
        return 0;
 a1a:	4781                	li	a5,0
 a1c:	a819                	j	a32 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1e:	fe843783          	ld	a5,-24(s0)
 a22:	fef43023          	sd	a5,-32(s0)
 a26:	fe843783          	ld	a5,-24(s0)
 a2a:	639c                	ld	a5,0(a5)
 a2c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 a30:	b799                	j	976 <malloc+0x76>
  }
}
 a32:	853e                	mv	a0,a5
 a34:	70e2                	ld	ra,56(sp)
 a36:	7442                	ld	s0,48(sp)
 a38:	6121                	addi	sp,sp,64
 a3a:	8082                	ret
