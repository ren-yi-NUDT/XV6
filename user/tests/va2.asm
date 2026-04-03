
user/tests/_va2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	00001797          	auipc	a5,0x1
   c:	9a878793          	addi	a5,a5,-1624 # 9b0 <malloc+0x13e>
  10:	fef43423          	sd	a5,-24(s0)
  14:	fe840593          	addi	a1,s0,-24
  18:	00001517          	auipc	a0,0x1
  1c:	9a050513          	addi	a0,a0,-1632 # 9b8 <malloc+0x146>
  20:	00000097          	auipc	ra,0x0
  24:	664080e7          	jalr	1636(ra) # 684 <printf>
  28:	fe040593          	addi	a1,s0,-32
  2c:	00001517          	auipc	a0,0x1
  30:	9a450513          	addi	a0,a0,-1628 # 9d0 <malloc+0x15e>
  34:	00000097          	auipc	ra,0x0
  38:	650080e7          	jalr	1616(ra) # 684 <printf>
  3c:	fe843583          	ld	a1,-24(s0)
  40:	00001517          	auipc	a0,0x1
  44:	9a850513          	addi	a0,a0,-1624 # 9e8 <malloc+0x176>
  48:	00000097          	auipc	ra,0x0
  4c:	63c080e7          	jalr	1596(ra) # 684 <printf>
  50:	fe043583          	ld	a1,-32(s0)
  54:	00001517          	auipc	a0,0x1
  58:	9ac50513          	addi	a0,a0,-1620 # a00 <malloc+0x18e>
  5c:	00000097          	auipc	ra,0x0
  60:	628080e7          	jalr	1576(ra) # 684 <printf>
  64:	fe843583          	ld	a1,-24(s0)
  68:	fe043503          	ld	a0,-32(s0)
  6c:	00000097          	auipc	ra,0x0
  70:	02c080e7          	jalr	44(ra) # 98 <strcpy>
  74:	4501                	li	a0,0
  76:	60e2                	ld	ra,24(sp)
  78:	6442                	ld	s0,16(sp)
  7a:	6105                	addi	sp,sp,32
  7c:	8082                	ret

000000000000007e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  extern int main();
  main();
  86:	00000097          	auipc	ra,0x0
  8a:	f7a080e7          	jalr	-134(ra) # 0 <main>
  exit(0);
  8e:	4501                	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	274080e7          	jalr	628(ra) # 304 <exit>

0000000000000098 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  98:	1141                	addi	sp,sp,-16
  9a:	e422                	sd	s0,8(sp)
  9c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9e:	87aa                	mv	a5,a0
  a0:	0585                	addi	a1,a1,1
  a2:	0785                	addi	a5,a5,1
  a4:	fff5c703          	lbu	a4,-1(a1)
  a8:	fee78fa3          	sb	a4,-1(a5)
  ac:	fb75                	bnez	a4,a0 <strcpy+0x8>
    ;
  return os;
}
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cb91                	beqz	a5,d2 <strcmp+0x1e>
  c0:	0005c703          	lbu	a4,0(a1)
  c4:	00f71763          	bne	a4,a5,d2 <strcmp+0x1e>
    p++, q++;
  c8:	0505                	addi	a0,a0,1
  ca:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	fbe5                	bnez	a5,c0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d2:	0005c503          	lbu	a0,0(a1)
}
  d6:	40a7853b          	subw	a0,a5,a0
  da:	6422                	ld	s0,8(sp)
  dc:	0141                	addi	sp,sp,16
  de:	8082                	ret

00000000000000e0 <strlen>:

uint
strlen(const char *s)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e422                	sd	s0,8(sp)
  e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e6:	00054783          	lbu	a5,0(a0)
  ea:	cf91                	beqz	a5,106 <strlen+0x26>
  ec:	0505                	addi	a0,a0,1
  ee:	87aa                	mv	a5,a0
  f0:	86be                	mv	a3,a5
  f2:	0785                	addi	a5,a5,1
  f4:	fff7c703          	lbu	a4,-1(a5)
  f8:	ff65                	bnez	a4,f0 <strlen+0x10>
  fa:	40a6853b          	subw	a0,a3,a0
  fe:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret
  for(n = 0; s[n]; n++)
 106:	4501                	li	a0,0
 108:	bfe5                	j	100 <strlen+0x20>

000000000000010a <memset>:

void*
memset(void *dst, int c, uint n)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e422                	sd	s0,8(sp)
 10e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 110:	ca19                	beqz	a2,126 <memset+0x1c>
 112:	87aa                	mv	a5,a0
 114:	1602                	slli	a2,a2,0x20
 116:	9201                	srli	a2,a2,0x20
 118:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 120:	0785                	addi	a5,a5,1
 122:	fee79de3          	bne	a5,a4,11c <memset+0x12>
  }
  return dst;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strchr>:

char*
strchr(const char *s, char c)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  for(; *s; s++)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb99                	beqz	a5,14c <strchr+0x20>
    if(*s == c)
 138:	00f58763          	beq	a1,a5,146 <strchr+0x1a>
  for(; *s; s++)
 13c:	0505                	addi	a0,a0,1
 13e:	00054783          	lbu	a5,0(a0)
 142:	fbfd                	bnez	a5,138 <strchr+0xc>
      return (char*)s;
  return 0;
 144:	4501                	li	a0,0
}
 146:	6422                	ld	s0,8(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret
  return 0;
 14c:	4501                	li	a0,0
 14e:	bfe5                	j	146 <strchr+0x1a>

0000000000000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	711d                	addi	sp,sp,-96
 152:	ec86                	sd	ra,88(sp)
 154:	e8a2                	sd	s0,80(sp)
 156:	e4a6                	sd	s1,72(sp)
 158:	e0ca                	sd	s2,64(sp)
 15a:	fc4e                	sd	s3,56(sp)
 15c:	f852                	sd	s4,48(sp)
 15e:	f456                	sd	s5,40(sp)
 160:	f05a                	sd	s6,32(sp)
 162:	ec5e                	sd	s7,24(sp)
 164:	1080                	addi	s0,sp,96
 166:	8baa                	mv	s7,a0
 168:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16a:	892a                	mv	s2,a0
 16c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16e:	4aa9                	li	s5,10
 170:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 172:	89a6                	mv	s3,s1
 174:	2485                	addiw	s1,s1,1
 176:	0344d863          	bge	s1,s4,1a6 <gets+0x56>
    cc = read(0, &c, 1);
 17a:	4605                	li	a2,1
 17c:	faf40593          	addi	a1,s0,-81
 180:	4501                	li	a0,0
 182:	00000097          	auipc	ra,0x0
 186:	19a080e7          	jalr	410(ra) # 31c <read>
    if(cc < 1)
 18a:	00a05e63          	blez	a0,1a6 <gets+0x56>
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 196:	01578763          	beq	a5,s5,1a4 <gets+0x54>
 19a:	0905                	addi	s2,s2,1
 19c:	fd679be3          	bne	a5,s6,172 <gets+0x22>
    buf[i++] = c;
 1a0:	89a6                	mv	s3,s1
 1a2:	a011                	j	1a6 <gets+0x56>
 1a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a6:	99de                	add	s3,s3,s7
 1a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	00000097          	auipc	ra,0x0
 1d6:	172080e7          	jalr	370(ra) # 344 <open>
  if(fd < 0)
 1da:	02054663          	bltz	a0,206 <stat+0x42>
 1de:	e426                	sd	s1,8(sp)
 1e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e2:	85ca                	mv	a1,s2
 1e4:	00000097          	auipc	ra,0x0
 1e8:	178080e7          	jalr	376(ra) # 35c <fstat>
 1ec:	892a                	mv	s2,a0
  close(fd);
 1ee:	8526                	mv	a0,s1
 1f0:	00000097          	auipc	ra,0x0
 1f4:	13c080e7          	jalr	316(ra) # 32c <close>
  return r;
 1f8:	64a2                	ld	s1,8(sp)
}
 1fa:	854a                	mv	a0,s2
 1fc:	60e2                	ld	ra,24(sp)
 1fe:	6442                	ld	s0,16(sp)
 200:	6902                	ld	s2,0(sp)
 202:	6105                	addi	sp,sp,32
 204:	8082                	ret
    return -1;
 206:	597d                	li	s2,-1
 208:	bfcd                	j	1fa <stat+0x36>

000000000000020a <atoi>:

int
atoi(const char *s)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 210:	00054683          	lbu	a3,0(a0)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	4625                	li	a2,9
 21e:	02f66863          	bltu	a2,a5,24e <atoi+0x44>
 222:	872a                	mv	a4,a0
  n = 0;
 224:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 226:	0705                	addi	a4,a4,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb5                	addw	a5,a5,a3
 234:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 238:	00074683          	lbu	a3,0(a4)
 23c:	fd06879b          	addiw	a5,a3,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	fef671e3          	bgeu	a2,a5,226 <atoi+0x1c>
  return n;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  n = 0;
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <atoi+0x3e>

0000000000000252 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 258:	02b57463          	bgeu	a0,a1,280 <memmove+0x2e>
    while(n-- > 0)
 25c:	00c05f63          	blez	a2,27a <memmove+0x28>
 260:	1602                	slli	a2,a2,0x20
 262:	9201                	srli	a2,a2,0x20
 264:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 268:	872a                	mv	a4,a0
      *dst++ = *src++;
 26a:	0585                	addi	a1,a1,1
 26c:	0705                	addi	a4,a4,1
 26e:	fff5c683          	lbu	a3,-1(a1)
 272:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 276:	fef71ae3          	bne	a4,a5,26a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
    dst += n;
 280:	00c50733          	add	a4,a0,a2
    src += n;
 284:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 286:	fec05ae3          	blez	a2,27a <memmove+0x28>
 28a:	fff6079b          	addiw	a5,a2,-1
 28e:	1782                	slli	a5,a5,0x20
 290:	9381                	srli	a5,a5,0x20
 292:	fff7c793          	not	a5,a5
 296:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 298:	15fd                	addi	a1,a1,-1
 29a:	177d                	addi	a4,a4,-1
 29c:	0005c683          	lbu	a3,0(a1)
 2a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a4:	fee79ae3          	bne	a5,a4,298 <memmove+0x46>
 2a8:	bfc9                	j	27a <memmove+0x28>

00000000000002aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b0:	ca05                	beqz	a2,2e0 <memcmp+0x36>
 2b2:	fff6069b          	addiw	a3,a2,-1
 2b6:	1682                	slli	a3,a3,0x20
 2b8:	9281                	srli	a3,a3,0x20
 2ba:	0685                	addi	a3,a3,1
 2bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	0005c703          	lbu	a4,0(a1)
 2c6:	00e79863          	bne	a5,a4,2d6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ca:	0505                	addi	a0,a0,1
    p2++;
 2cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ce:	fed518e3          	bne	a0,a3,2be <memcmp+0x14>
  }
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	a019                	j	2da <memcmp+0x30>
      return *p1 - *p2;
 2d6:	40e7853b          	subw	a0,a5,a4
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  return 0;
 2e0:	4501                	li	a0,0
 2e2:	bfe5                	j	2da <memcmp+0x30>

00000000000002e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ec:	00000097          	auipc	ra,0x0
 2f0:	f66080e7          	jalr	-154(ra) # 252 <memmove>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <yield>:
.global yield
yield:
 li a7, SYS_yield
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <lock>:
.global lock
lock:
 li a7, SYS_lock
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 3b4:	48e1                	li	a7,24
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3bc:	1101                	addi	sp,sp,-32
 3be:	ec06                	sd	ra,24(sp)
 3c0:	e822                	sd	s0,16(sp)
 3c2:	1000                	addi	s0,sp,32
 3c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c8:	4605                	li	a2,1
 3ca:	fef40593          	addi	a1,s0,-17
 3ce:	00000097          	auipc	ra,0x0
 3d2:	f56080e7          	jalr	-170(ra) # 324 <write>
}
 3d6:	60e2                	ld	ra,24(sp)
 3d8:	6442                	ld	s0,16(sp)
 3da:	6105                	addi	sp,sp,32
 3dc:	8082                	ret

00000000000003de <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3de:	7139                	addi	sp,sp,-64
 3e0:	fc06                	sd	ra,56(sp)
 3e2:	f822                	sd	s0,48(sp)
 3e4:	f426                	sd	s1,40(sp)
 3e6:	0080                	addi	s0,sp,64
 3e8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ea:	c299                	beqz	a3,3f0 <printint+0x12>
 3ec:	0805cb63          	bltz	a1,482 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f0:	2581                	sext.w	a1,a1
  neg = 0;
 3f2:	4881                	li	a7,0
 3f4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3f8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fa:	2601                	sext.w	a2,a2
 3fc:	00000517          	auipc	a0,0x0
 400:	67c50513          	addi	a0,a0,1660 # a78 <digits>
 404:	883a                	mv	a6,a4
 406:	2705                	addiw	a4,a4,1
 408:	02c5f7bb          	remuw	a5,a1,a2
 40c:	1782                	slli	a5,a5,0x20
 40e:	9381                	srli	a5,a5,0x20
 410:	97aa                	add	a5,a5,a0
 412:	0007c783          	lbu	a5,0(a5)
 416:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 41a:	0005879b          	sext.w	a5,a1
 41e:	02c5d5bb          	divuw	a1,a1,a2
 422:	0685                	addi	a3,a3,1
 424:	fec7f0e3          	bgeu	a5,a2,404 <printint+0x26>
  if(neg)
 428:	00088c63          	beqz	a7,440 <printint+0x62>
    buf[i++] = '-';
 42c:	fd070793          	addi	a5,a4,-48
 430:	00878733          	add	a4,a5,s0
 434:	02d00793          	li	a5,45
 438:	fef70823          	sb	a5,-16(a4)
 43c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 440:	02e05c63          	blez	a4,478 <printint+0x9a>
 444:	f04a                	sd	s2,32(sp)
 446:	ec4e                	sd	s3,24(sp)
 448:	fc040793          	addi	a5,s0,-64
 44c:	00e78933          	add	s2,a5,a4
 450:	fff78993          	addi	s3,a5,-1
 454:	99ba                	add	s3,s3,a4
 456:	377d                	addiw	a4,a4,-1
 458:	1702                	slli	a4,a4,0x20
 45a:	9301                	srli	a4,a4,0x20
 45c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 460:	fff94583          	lbu	a1,-1(s2)
 464:	8526                	mv	a0,s1
 466:	00000097          	auipc	ra,0x0
 46a:	f56080e7          	jalr	-170(ra) # 3bc <putc>
  while(--i >= 0)
 46e:	197d                	addi	s2,s2,-1
 470:	ff3918e3          	bne	s2,s3,460 <printint+0x82>
 474:	7902                	ld	s2,32(sp)
 476:	69e2                	ld	s3,24(sp)
}
 478:	70e2                	ld	ra,56(sp)
 47a:	7442                	ld	s0,48(sp)
 47c:	74a2                	ld	s1,40(sp)
 47e:	6121                	addi	sp,sp,64
 480:	8082                	ret
    x = -xx;
 482:	40b005bb          	negw	a1,a1
    neg = 1;
 486:	4885                	li	a7,1
    x = -xx;
 488:	b7b5                	j	3f4 <printint+0x16>

000000000000048a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48a:	715d                	addi	sp,sp,-80
 48c:	e486                	sd	ra,72(sp)
 48e:	e0a2                	sd	s0,64(sp)
 490:	f84a                	sd	s2,48(sp)
 492:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 494:	0005c903          	lbu	s2,0(a1)
 498:	1a090a63          	beqz	s2,64c <vprintf+0x1c2>
 49c:	fc26                	sd	s1,56(sp)
 49e:	f44e                	sd	s3,40(sp)
 4a0:	f052                	sd	s4,32(sp)
 4a2:	ec56                	sd	s5,24(sp)
 4a4:	e85a                	sd	s6,16(sp)
 4a6:	e45e                	sd	s7,8(sp)
 4a8:	8aaa                	mv	s5,a0
 4aa:	8bb2                	mv	s7,a2
 4ac:	00158493          	addi	s1,a1,1
  state = 0;
 4b0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b2:	02500a13          	li	s4,37
 4b6:	4b55                	li	s6,21
 4b8:	a839                	j	4d6 <vprintf+0x4c>
        putc(fd, c);
 4ba:	85ca                	mv	a1,s2
 4bc:	8556                	mv	a0,s5
 4be:	00000097          	auipc	ra,0x0
 4c2:	efe080e7          	jalr	-258(ra) # 3bc <putc>
 4c6:	a019                	j	4cc <vprintf+0x42>
    } else if(state == '%'){
 4c8:	01498d63          	beq	s3,s4,4e2 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4cc:	0485                	addi	s1,s1,1
 4ce:	fff4c903          	lbu	s2,-1(s1)
 4d2:	16090763          	beqz	s2,640 <vprintf+0x1b6>
    if(state == 0){
 4d6:	fe0999e3          	bnez	s3,4c8 <vprintf+0x3e>
      if(c == '%'){
 4da:	ff4910e3          	bne	s2,s4,4ba <vprintf+0x30>
        state = '%';
 4de:	89d2                	mv	s3,s4
 4e0:	b7f5                	j	4cc <vprintf+0x42>
      if(c == 'd'){
 4e2:	13490463          	beq	s2,s4,60a <vprintf+0x180>
 4e6:	f9d9079b          	addiw	a5,s2,-99
 4ea:	0ff7f793          	zext.b	a5,a5
 4ee:	12fb6763          	bltu	s6,a5,61c <vprintf+0x192>
 4f2:	f9d9079b          	addiw	a5,s2,-99
 4f6:	0ff7f713          	zext.b	a4,a5
 4fa:	12eb6163          	bltu	s6,a4,61c <vprintf+0x192>
 4fe:	00271793          	slli	a5,a4,0x2
 502:	00000717          	auipc	a4,0x0
 506:	51e70713          	addi	a4,a4,1310 # a20 <malloc+0x1ae>
 50a:	97ba                	add	a5,a5,a4
 50c:	439c                	lw	a5,0(a5)
 50e:	97ba                	add	a5,a5,a4
 510:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 512:	008b8913          	addi	s2,s7,8
 516:	4685                	li	a3,1
 518:	4629                	li	a2,10
 51a:	000ba583          	lw	a1,0(s7)
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	ebe080e7          	jalr	-322(ra) # 3de <printint>
 528:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 52a:	4981                	li	s3,0
 52c:	b745                	j	4cc <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 52e:	008b8913          	addi	s2,s7,8
 532:	4681                	li	a3,0
 534:	4629                	li	a2,10
 536:	000ba583          	lw	a1,0(s7)
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	ea2080e7          	jalr	-350(ra) # 3de <printint>
 544:	8bca                	mv	s7,s2
      state = 0;
 546:	4981                	li	s3,0
 548:	b751                	j	4cc <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 54a:	008b8913          	addi	s2,s7,8
 54e:	4681                	li	a3,0
 550:	4641                	li	a2,16
 552:	000ba583          	lw	a1,0(s7)
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	e86080e7          	jalr	-378(ra) # 3de <printint>
 560:	8bca                	mv	s7,s2
      state = 0;
 562:	4981                	li	s3,0
 564:	b7a5                	j	4cc <vprintf+0x42>
 566:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 568:	008b8c13          	addi	s8,s7,8
 56c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 570:	03000593          	li	a1,48
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e46080e7          	jalr	-442(ra) # 3bc <putc>
  putc(fd, 'x');
 57e:	07800593          	li	a1,120
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	e38080e7          	jalr	-456(ra) # 3bc <putc>
 58c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 58e:	00000b97          	auipc	s7,0x0
 592:	4eab8b93          	addi	s7,s7,1258 # a78 <digits>
 596:	03c9d793          	srli	a5,s3,0x3c
 59a:	97de                	add	a5,a5,s7
 59c:	0007c583          	lbu	a1,0(a5)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e1a080e7          	jalr	-486(ra) # 3bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5aa:	0992                	slli	s3,s3,0x4
 5ac:	397d                	addiw	s2,s2,-1
 5ae:	fe0914e3          	bnez	s2,596 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5b2:	8be2                	mv	s7,s8
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	6c02                	ld	s8,0(sp)
 5b8:	bf11                	j	4cc <vprintf+0x42>
        s = va_arg(ap, char*);
 5ba:	008b8993          	addi	s3,s7,8
 5be:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5c2:	02090163          	beqz	s2,5e4 <vprintf+0x15a>
        while(*s != 0){
 5c6:	00094583          	lbu	a1,0(s2)
 5ca:	c9a5                	beqz	a1,63a <vprintf+0x1b0>
          putc(fd, *s);
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	dee080e7          	jalr	-530(ra) # 3bc <putc>
          s++;
 5d6:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d8:	00094583          	lbu	a1,0(s2)
 5dc:	f9e5                	bnez	a1,5cc <vprintf+0x142>
        s = va_arg(ap, char*);
 5de:	8bce                	mv	s7,s3
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b5ed                	j	4cc <vprintf+0x42>
          s = "(null)";
 5e4:	00000917          	auipc	s2,0x0
 5e8:	43490913          	addi	s2,s2,1076 # a18 <malloc+0x1a6>
        while(*s != 0){
 5ec:	02800593          	li	a1,40
 5f0:	bff1                	j	5cc <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	000bc583          	lbu	a1,0(s7)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	dc0080e7          	jalr	-576(ra) # 3bc <putc>
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	b5d1                	j	4cc <vprintf+0x42>
        putc(fd, c);
 60a:	02500593          	li	a1,37
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	dac080e7          	jalr	-596(ra) # 3bc <putc>
      state = 0;
 618:	4981                	li	s3,0
 61a:	bd4d                	j	4cc <vprintf+0x42>
        putc(fd, '%');
 61c:	02500593          	li	a1,37
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	d9a080e7          	jalr	-614(ra) # 3bc <putc>
        putc(fd, c);
 62a:	85ca                	mv	a1,s2
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	d8e080e7          	jalr	-626(ra) # 3bc <putc>
      state = 0;
 636:	4981                	li	s3,0
 638:	bd51                	j	4cc <vprintf+0x42>
        s = va_arg(ap, char*);
 63a:	8bce                	mv	s7,s3
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b579                	j	4cc <vprintf+0x42>
 640:	74e2                	ld	s1,56(sp)
 642:	79a2                	ld	s3,40(sp)
 644:	7a02                	ld	s4,32(sp)
 646:	6ae2                	ld	s5,24(sp)
 648:	6b42                	ld	s6,16(sp)
 64a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 64c:	60a6                	ld	ra,72(sp)
 64e:	6406                	ld	s0,64(sp)
 650:	7942                	ld	s2,48(sp)
 652:	6161                	addi	sp,sp,80
 654:	8082                	ret

0000000000000656 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 656:	715d                	addi	sp,sp,-80
 658:	ec06                	sd	ra,24(sp)
 65a:	e822                	sd	s0,16(sp)
 65c:	1000                	addi	s0,sp,32
 65e:	e010                	sd	a2,0(s0)
 660:	e414                	sd	a3,8(s0)
 662:	e818                	sd	a4,16(s0)
 664:	ec1c                	sd	a5,24(s0)
 666:	03043023          	sd	a6,32(s0)
 66a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 66e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 672:	8622                	mv	a2,s0
 674:	00000097          	auipc	ra,0x0
 678:	e16080e7          	jalr	-490(ra) # 48a <vprintf>
}
 67c:	60e2                	ld	ra,24(sp)
 67e:	6442                	ld	s0,16(sp)
 680:	6161                	addi	sp,sp,80
 682:	8082                	ret

0000000000000684 <printf>:

void
printf(const char *fmt, ...)
{
 684:	7159                	addi	sp,sp,-112
 686:	f406                	sd	ra,40(sp)
 688:	f022                	sd	s0,32(sp)
 68a:	ec26                	sd	s1,24(sp)
 68c:	1800                	addi	s0,sp,48
 68e:	84aa                	mv	s1,a0
 690:	e40c                	sd	a1,8(s0)
 692:	e810                	sd	a2,16(s0)
 694:	ec14                	sd	a3,24(s0)
 696:	f018                	sd	a4,32(s0)
 698:	f41c                	sd	a5,40(s0)
 69a:	03043823          	sd	a6,48(s0)
 69e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 6a2:	00000097          	auipc	ra,0x0
 6a6:	d0a080e7          	jalr	-758(ra) # 3ac <lock>
  va_start(ap, fmt);
 6aa:	00840613          	addi	a2,s0,8
 6ae:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 6b2:	85a6                	mv	a1,s1
 6b4:	4505                	li	a0,1
 6b6:	00000097          	auipc	ra,0x0
 6ba:	dd4080e7          	jalr	-556(ra) # 48a <vprintf>
  unlock();
 6be:	00000097          	auipc	ra,0x0
 6c2:	cf6080e7          	jalr	-778(ra) # 3b4 <unlock>
}
 6c6:	70a2                	ld	ra,40(sp)
 6c8:	7402                	ld	s0,32(sp)
 6ca:	64e2                	ld	s1,24(sp)
 6cc:	6165                	addi	sp,sp,112
 6ce:	8082                	ret

00000000000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	7179                	addi	sp,sp,-48
 6d2:	f422                	sd	s0,40(sp)
 6d4:	1800                	addi	s0,sp,48
 6d6:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6da:	fd843783          	ld	a5,-40(s0)
 6de:	17c1                	addi	a5,a5,-16
 6e0:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	00001797          	auipc	a5,0x1
 6e8:	cec78793          	addi	a5,a5,-788 # 13d0 <freep>
 6ec:	639c                	ld	a5,0(a5)
 6ee:	fef43423          	sd	a5,-24(s0)
 6f2:	a815                	j	726 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f4:	fe843783          	ld	a5,-24(s0)
 6f8:	639c                	ld	a5,0(a5)
 6fa:	fe843703          	ld	a4,-24(s0)
 6fe:	00f76f63          	bltu	a4,a5,71c <free+0x4c>
 702:	fe043703          	ld	a4,-32(s0)
 706:	fe843783          	ld	a5,-24(s0)
 70a:	02e7eb63          	bltu	a5,a4,740 <free+0x70>
 70e:	fe843783          	ld	a5,-24(s0)
 712:	639c                	ld	a5,0(a5)
 714:	fe043703          	ld	a4,-32(s0)
 718:	02f76463          	bltu	a4,a5,740 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71c:	fe843783          	ld	a5,-24(s0)
 720:	639c                	ld	a5,0(a5)
 722:	fef43423          	sd	a5,-24(s0)
 726:	fe043703          	ld	a4,-32(s0)
 72a:	fe843783          	ld	a5,-24(s0)
 72e:	fce7f3e3          	bgeu	a5,a4,6f4 <free+0x24>
 732:	fe843783          	ld	a5,-24(s0)
 736:	639c                	ld	a5,0(a5)
 738:	fe043703          	ld	a4,-32(s0)
 73c:	faf77ce3          	bgeu	a4,a5,6f4 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 740:	fe043783          	ld	a5,-32(s0)
 744:	479c                	lw	a5,8(a5)
 746:	1782                	slli	a5,a5,0x20
 748:	9381                	srli	a5,a5,0x20
 74a:	0792                	slli	a5,a5,0x4
 74c:	fe043703          	ld	a4,-32(s0)
 750:	973e                	add	a4,a4,a5
 752:	fe843783          	ld	a5,-24(s0)
 756:	639c                	ld	a5,0(a5)
 758:	02f71763          	bne	a4,a5,786 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 75c:	fe043783          	ld	a5,-32(s0)
 760:	4798                	lw	a4,8(a5)
 762:	fe843783          	ld	a5,-24(s0)
 766:	639c                	ld	a5,0(a5)
 768:	479c                	lw	a5,8(a5)
 76a:	9fb9                	addw	a5,a5,a4
 76c:	0007871b          	sext.w	a4,a5
 770:	fe043783          	ld	a5,-32(s0)
 774:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 776:	fe843783          	ld	a5,-24(s0)
 77a:	639c                	ld	a5,0(a5)
 77c:	6398                	ld	a4,0(a5)
 77e:	fe043783          	ld	a5,-32(s0)
 782:	e398                	sd	a4,0(a5)
 784:	a039                	j	792 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 786:	fe843783          	ld	a5,-24(s0)
 78a:	6398                	ld	a4,0(a5)
 78c:	fe043783          	ld	a5,-32(s0)
 790:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 792:	fe843783          	ld	a5,-24(s0)
 796:	479c                	lw	a5,8(a5)
 798:	1782                	slli	a5,a5,0x20
 79a:	9381                	srli	a5,a5,0x20
 79c:	0792                	slli	a5,a5,0x4
 79e:	fe843703          	ld	a4,-24(s0)
 7a2:	97ba                	add	a5,a5,a4
 7a4:	fe043703          	ld	a4,-32(s0)
 7a8:	02f71563          	bne	a4,a5,7d2 <free+0x102>
    p->s.size += bp->s.size;
 7ac:	fe843783          	ld	a5,-24(s0)
 7b0:	4798                	lw	a4,8(a5)
 7b2:	fe043783          	ld	a5,-32(s0)
 7b6:	479c                	lw	a5,8(a5)
 7b8:	9fb9                	addw	a5,a5,a4
 7ba:	0007871b          	sext.w	a4,a5
 7be:	fe843783          	ld	a5,-24(s0)
 7c2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c4:	fe043783          	ld	a5,-32(s0)
 7c8:	6398                	ld	a4,0(a5)
 7ca:	fe843783          	ld	a5,-24(s0)
 7ce:	e398                	sd	a4,0(a5)
 7d0:	a031                	j	7dc <free+0x10c>
  } else
    p->s.ptr = bp;
 7d2:	fe843783          	ld	a5,-24(s0)
 7d6:	fe043703          	ld	a4,-32(s0)
 7da:	e398                	sd	a4,0(a5)
  freep = p;
 7dc:	00001797          	auipc	a5,0x1
 7e0:	bf478793          	addi	a5,a5,-1036 # 13d0 <freep>
 7e4:	fe843703          	ld	a4,-24(s0)
 7e8:	e398                	sd	a4,0(a5)
}
 7ea:	0001                	nop
 7ec:	7422                	ld	s0,40(sp)
 7ee:	6145                	addi	sp,sp,48
 7f0:	8082                	ret

00000000000007f2 <morecore>:

static Header*
morecore(uint nu)
{
 7f2:	7179                	addi	sp,sp,-48
 7f4:	f406                	sd	ra,40(sp)
 7f6:	f022                	sd	s0,32(sp)
 7f8:	1800                	addi	s0,sp,48
 7fa:	87aa                	mv	a5,a0
 7fc:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 800:	fdc42783          	lw	a5,-36(s0)
 804:	0007871b          	sext.w	a4,a5
 808:	6785                	lui	a5,0x1
 80a:	00f77563          	bgeu	a4,a5,814 <morecore+0x22>
    nu = 4096;
 80e:	6785                	lui	a5,0x1
 810:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 814:	fdc42783          	lw	a5,-36(s0)
 818:	0047979b          	slliw	a5,a5,0x4
 81c:	2781                	sext.w	a5,a5
 81e:	2781                	sext.w	a5,a5
 820:	853e                	mv	a0,a5
 822:	00000097          	auipc	ra,0x0
 826:	b6a080e7          	jalr	-1174(ra) # 38c <sbrk>
 82a:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 82e:	fe843703          	ld	a4,-24(s0)
 832:	57fd                	li	a5,-1
 834:	00f71463          	bne	a4,a5,83c <morecore+0x4a>
    return 0;
 838:	4781                	li	a5,0
 83a:	a03d                	j	868 <morecore+0x76>
  hp = (Header*)p;
 83c:	fe843783          	ld	a5,-24(s0)
 840:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 844:	fe043783          	ld	a5,-32(s0)
 848:	fdc42703          	lw	a4,-36(s0)
 84c:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 84e:	fe043783          	ld	a5,-32(s0)
 852:	07c1                	addi	a5,a5,16 # 1010 <digits+0x598>
 854:	853e                	mv	a0,a5
 856:	00000097          	auipc	ra,0x0
 85a:	e7a080e7          	jalr	-390(ra) # 6d0 <free>
  return freep;
 85e:	00001797          	auipc	a5,0x1
 862:	b7278793          	addi	a5,a5,-1166 # 13d0 <freep>
 866:	639c                	ld	a5,0(a5)
}
 868:	853e                	mv	a0,a5
 86a:	70a2                	ld	ra,40(sp)
 86c:	7402                	ld	s0,32(sp)
 86e:	6145                	addi	sp,sp,48
 870:	8082                	ret

0000000000000872 <malloc>:

void*
malloc(uint nbytes)
{
 872:	7139                	addi	sp,sp,-64
 874:	fc06                	sd	ra,56(sp)
 876:	f822                	sd	s0,48(sp)
 878:	0080                	addi	s0,sp,64
 87a:	87aa                	mv	a5,a0
 87c:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 880:	fcc46783          	lwu	a5,-52(s0)
 884:	07bd                	addi	a5,a5,15
 886:	8391                	srli	a5,a5,0x4
 888:	2781                	sext.w	a5,a5
 88a:	2785                	addiw	a5,a5,1
 88c:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 890:	00001797          	auipc	a5,0x1
 894:	b4078793          	addi	a5,a5,-1216 # 13d0 <freep>
 898:	639c                	ld	a5,0(a5)
 89a:	fef43023          	sd	a5,-32(s0)
 89e:	fe043783          	ld	a5,-32(s0)
 8a2:	ef95                	bnez	a5,8de <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 8a4:	00001797          	auipc	a5,0x1
 8a8:	b1c78793          	addi	a5,a5,-1252 # 13c0 <base>
 8ac:	fef43023          	sd	a5,-32(s0)
 8b0:	00001797          	auipc	a5,0x1
 8b4:	b2078793          	addi	a5,a5,-1248 # 13d0 <freep>
 8b8:	fe043703          	ld	a4,-32(s0)
 8bc:	e398                	sd	a4,0(a5)
 8be:	00001797          	auipc	a5,0x1
 8c2:	b1278793          	addi	a5,a5,-1262 # 13d0 <freep>
 8c6:	6398                	ld	a4,0(a5)
 8c8:	00001797          	auipc	a5,0x1
 8cc:	af878793          	addi	a5,a5,-1288 # 13c0 <base>
 8d0:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 8d2:	00001797          	auipc	a5,0x1
 8d6:	aee78793          	addi	a5,a5,-1298 # 13c0 <base>
 8da:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8de:	fe043783          	ld	a5,-32(s0)
 8e2:	639c                	ld	a5,0(a5)
 8e4:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 8e8:	fe843783          	ld	a5,-24(s0)
 8ec:	4798                	lw	a4,8(a5)
 8ee:	fdc42783          	lw	a5,-36(s0)
 8f2:	2781                	sext.w	a5,a5
 8f4:	06f76763          	bltu	a4,a5,962 <malloc+0xf0>
      if(p->s.size == nunits)
 8f8:	fe843783          	ld	a5,-24(s0)
 8fc:	4798                	lw	a4,8(a5)
 8fe:	fdc42783          	lw	a5,-36(s0)
 902:	2781                	sext.w	a5,a5
 904:	00e79963          	bne	a5,a4,916 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 908:	fe843783          	ld	a5,-24(s0)
 90c:	6398                	ld	a4,0(a5)
 90e:	fe043783          	ld	a5,-32(s0)
 912:	e398                	sd	a4,0(a5)
 914:	a825                	j	94c <malloc+0xda>
      else {
        p->s.size -= nunits;
 916:	fe843783          	ld	a5,-24(s0)
 91a:	479c                	lw	a5,8(a5)
 91c:	fdc42703          	lw	a4,-36(s0)
 920:	9f99                	subw	a5,a5,a4
 922:	0007871b          	sext.w	a4,a5
 926:	fe843783          	ld	a5,-24(s0)
 92a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 92c:	fe843783          	ld	a5,-24(s0)
 930:	479c                	lw	a5,8(a5)
 932:	1782                	slli	a5,a5,0x20
 934:	9381                	srli	a5,a5,0x20
 936:	0792                	slli	a5,a5,0x4
 938:	fe843703          	ld	a4,-24(s0)
 93c:	97ba                	add	a5,a5,a4
 93e:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 942:	fe843783          	ld	a5,-24(s0)
 946:	fdc42703          	lw	a4,-36(s0)
 94a:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 94c:	00001797          	auipc	a5,0x1
 950:	a8478793          	addi	a5,a5,-1404 # 13d0 <freep>
 954:	fe043703          	ld	a4,-32(s0)
 958:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 95a:	fe843783          	ld	a5,-24(s0)
 95e:	07c1                	addi	a5,a5,16
 960:	a091                	j	9a4 <malloc+0x132>
    }
    if(p == freep)
 962:	00001797          	auipc	a5,0x1
 966:	a6e78793          	addi	a5,a5,-1426 # 13d0 <freep>
 96a:	639c                	ld	a5,0(a5)
 96c:	fe843703          	ld	a4,-24(s0)
 970:	02f71063          	bne	a4,a5,990 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 974:	fdc42783          	lw	a5,-36(s0)
 978:	853e                	mv	a0,a5
 97a:	00000097          	auipc	ra,0x0
 97e:	e78080e7          	jalr	-392(ra) # 7f2 <morecore>
 982:	fea43423          	sd	a0,-24(s0)
 986:	fe843783          	ld	a5,-24(s0)
 98a:	e399                	bnez	a5,990 <malloc+0x11e>
        return 0;
 98c:	4781                	li	a5,0
 98e:	a819                	j	9a4 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	fe843783          	ld	a5,-24(s0)
 994:	fef43023          	sd	a5,-32(s0)
 998:	fe843783          	ld	a5,-24(s0)
 99c:	639c                	ld	a5,0(a5)
 99e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 9a2:	b799                	j	8e8 <malloc+0x76>
  }
}
 9a4:	853e                	mv	a0,a5
 9a6:	70e2                	ld	ra,56(sp)
 9a8:	7442                	ld	s0,48(sp)
 9aa:	6121                	addi	sp,sp,64
 9ac:	8082                	ret
