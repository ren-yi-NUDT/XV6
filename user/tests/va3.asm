
user/tests/_va3:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	6505                	lui	a0,0x1
   e:	00001097          	auipc	ra,0x1
  12:	87a080e7          	jalr	-1926(ra) # 888 <malloc>
  16:	892a                	mv	s2,a0
  18:	85aa                	mv	a1,a0
  1a:	00001517          	auipc	a0,0x1
  1e:	9b650513          	addi	a0,a0,-1610 # 9d0 <malloc+0x148>
  22:	00000097          	auipc	ra,0x0
  26:	678080e7          	jalr	1656(ra) # 69a <printf>
  2a:	6541                	lui	a0,0x10
  2c:	00001097          	auipc	ra,0x1
  30:	85c080e7          	jalr	-1956(ra) # 888 <malloc>
  34:	84aa                	mv	s1,a0
  36:	85aa                	mv	a1,a0
  38:	00001517          	auipc	a0,0x1
  3c:	9c050513          	addi	a0,a0,-1600 # 9f8 <malloc+0x170>
  40:	00000097          	auipc	ra,0x0
  44:	65a080e7          	jalr	1626(ra) # 69a <printf>
  48:	8526                	mv	a0,s1
  4a:	00000097          	auipc	ra,0x0
  4e:	69c080e7          	jalr	1692(ra) # 6e6 <free>
  52:	10000513          	li	a0,256
  56:	00001097          	auipc	ra,0x1
  5a:	832080e7          	jalr	-1998(ra) # 888 <malloc>
  5e:	84aa                	mv	s1,a0
  60:	85aa                	mv	a1,a0
  62:	00001517          	auipc	a0,0x1
  66:	9be50513          	addi	a0,a0,-1602 # a20 <malloc+0x198>
  6a:	00000097          	auipc	ra,0x0
  6e:	630080e7          	jalr	1584(ra) # 69a <printf>
  72:	854a                	mv	a0,s2
  74:	00000097          	auipc	ra,0x0
  78:	672080e7          	jalr	1650(ra) # 6e6 <free>
  7c:	8526                	mv	a0,s1
  7e:	00000097          	auipc	ra,0x0
  82:	668080e7          	jalr	1640(ra) # 6e6 <free>
  86:	4501                	li	a0,0
  88:	60e2                	ld	ra,24(sp)
  8a:	6442                	ld	s0,16(sp)
  8c:	64a2                	ld	s1,8(sp)
  8e:	6902                	ld	s2,0(sp)
  90:	6105                	addi	sp,sp,32
  92:	8082                	ret

0000000000000094 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  94:	1141                	addi	sp,sp,-16
  96:	e406                	sd	ra,8(sp)
  98:	e022                	sd	s0,0(sp)
  9a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  9c:	00000097          	auipc	ra,0x0
  a0:	f64080e7          	jalr	-156(ra) # 0 <main>
  exit(0);
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	274080e7          	jalr	628(ra) # 31a <exit>

00000000000000ae <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b4:	87aa                	mv	a5,a0
  b6:	0585                	addi	a1,a1,1
  b8:	0785                	addi	a5,a5,1
  ba:	fff5c703          	lbu	a4,-1(a1)
  be:	fee78fa3          	sb	a4,-1(a5)
  c2:	fb75                	bnez	a4,b6 <strcpy+0x8>
    ;
  return os;
}
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cb91                	beqz	a5,e8 <strcmp+0x1e>
  d6:	0005c703          	lbu	a4,0(a1)
  da:	00f71763          	bne	a4,a5,e8 <strcmp+0x1e>
    p++, q++;
  de:	0505                	addi	a0,a0,1
  e0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	fbe5                	bnez	a5,d6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e8:	0005c503          	lbu	a0,0(a1)
}
  ec:	40a7853b          	subw	a0,a5,a0
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strlen>:

uint
strlen(const char *s)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  fc:	00054783          	lbu	a5,0(a0)
 100:	cf91                	beqz	a5,11c <strlen+0x26>
 102:	0505                	addi	a0,a0,1
 104:	87aa                	mv	a5,a0
 106:	86be                	mv	a3,a5
 108:	0785                	addi	a5,a5,1
 10a:	fff7c703          	lbu	a4,-1(a5)
 10e:	ff65                	bnez	a4,106 <strlen+0x10>
 110:	40a6853b          	subw	a0,a3,a0
 114:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret
  for(n = 0; s[n]; n++)
 11c:	4501                	li	a0,0
 11e:	bfe5                	j	116 <strlen+0x20>

0000000000000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	1141                	addi	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 126:	ca19                	beqz	a2,13c <memset+0x1c>
 128:	87aa                	mv	a5,a0
 12a:	1602                	slli	a2,a2,0x20
 12c:	9201                	srli	a2,a2,0x20
 12e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 132:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 136:	0785                	addi	a5,a5,1
 138:	fee79de3          	bne	a5,a4,132 <memset+0x12>
  }
  return dst;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strchr>:

char*
strchr(const char *s, char c)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  for(; *s; s++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb99                	beqz	a5,162 <strchr+0x20>
    if(*s == c)
 14e:	00f58763          	beq	a1,a5,15c <strchr+0x1a>
  for(; *s; s++)
 152:	0505                	addi	a0,a0,1
 154:	00054783          	lbu	a5,0(a0)
 158:	fbfd                	bnez	a5,14e <strchr+0xc>
      return (char*)s;
  return 0;
 15a:	4501                	li	a0,0
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfe5                	j	15c <strchr+0x1a>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	1080                	addi	s0,sp,96
 17c:	8baa                	mv	s7,a0
 17e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	892a                	mv	s2,a0
 182:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 184:	4aa9                	li	s5,10
 186:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 188:	89a6                	mv	s3,s1
 18a:	2485                	addiw	s1,s1,1
 18c:	0344d863          	bge	s1,s4,1bc <gets+0x56>
    cc = read(0, &c, 1);
 190:	4605                	li	a2,1
 192:	faf40593          	addi	a1,s0,-81
 196:	4501                	li	a0,0
 198:	00000097          	auipc	ra,0x0
 19c:	19a080e7          	jalr	410(ra) # 332 <read>
    if(cc < 1)
 1a0:	00a05e63          	blez	a0,1bc <gets+0x56>
    buf[i++] = c;
 1a4:	faf44783          	lbu	a5,-81(s0)
 1a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ac:	01578763          	beq	a5,s5,1ba <gets+0x54>
 1b0:	0905                	addi	s2,s2,1
 1b2:	fd679be3          	bne	a5,s6,188 <gets+0x22>
    buf[i++] = c;
 1b6:	89a6                	mv	s3,s1
 1b8:	a011                	j	1bc <gets+0x56>
 1ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1bc:	99de                	add	s3,s3,s7
 1be:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c2:	855e                	mv	a0,s7
 1c4:	60e6                	ld	ra,88(sp)
 1c6:	6446                	ld	s0,80(sp)
 1c8:	64a6                	ld	s1,72(sp)
 1ca:	6906                	ld	s2,64(sp)
 1cc:	79e2                	ld	s3,56(sp)
 1ce:	7a42                	ld	s4,48(sp)
 1d0:	7aa2                	ld	s5,40(sp)
 1d2:	7b02                	ld	s6,32(sp)
 1d4:	6be2                	ld	s7,24(sp)
 1d6:	6125                	addi	sp,sp,96
 1d8:	8082                	ret

00000000000001da <stat>:

int
stat(const char *n, struct stat *st)
{
 1da:	1101                	addi	sp,sp,-32
 1dc:	ec06                	sd	ra,24(sp)
 1de:	e822                	sd	s0,16(sp)
 1e0:	e04a                	sd	s2,0(sp)
 1e2:	1000                	addi	s0,sp,32
 1e4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e6:	4581                	li	a1,0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	172080e7          	jalr	370(ra) # 35a <open>
  if(fd < 0)
 1f0:	02054663          	bltz	a0,21c <stat+0x42>
 1f4:	e426                	sd	s1,8(sp)
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	00000097          	auipc	ra,0x0
 1fe:	178080e7          	jalr	376(ra) # 372 <fstat>
 202:	892a                	mv	s2,a0
  close(fd);
 204:	8526                	mv	a0,s1
 206:	00000097          	auipc	ra,0x0
 20a:	13c080e7          	jalr	316(ra) # 342 <close>
  return r;
 20e:	64a2                	ld	s1,8(sp)
}
 210:	854a                	mv	a0,s2
 212:	60e2                	ld	ra,24(sp)
 214:	6442                	ld	s0,16(sp)
 216:	6902                	ld	s2,0(sp)
 218:	6105                	addi	sp,sp,32
 21a:	8082                	ret
    return -1;
 21c:	597d                	li	s2,-1
 21e:	bfcd                	j	210 <stat+0x36>

0000000000000220 <atoi>:

int
atoi(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 226:	00054683          	lbu	a3,0(a0)
 22a:	fd06879b          	addiw	a5,a3,-48
 22e:	0ff7f793          	zext.b	a5,a5
 232:	4625                	li	a2,9
 234:	02f66863          	bltu	a2,a5,264 <atoi+0x44>
 238:	872a                	mv	a4,a0
  n = 0;
 23a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 23c:	0705                	addi	a4,a4,1
 23e:	0025179b          	slliw	a5,a0,0x2
 242:	9fa9                	addw	a5,a5,a0
 244:	0017979b          	slliw	a5,a5,0x1
 248:	9fb5                	addw	a5,a5,a3
 24a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 24e:	00074683          	lbu	a3,0(a4)
 252:	fd06879b          	addiw	a5,a3,-48
 256:	0ff7f793          	zext.b	a5,a5
 25a:	fef671e3          	bgeu	a2,a5,23c <atoi+0x1c>
  return n;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  n = 0;
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <atoi+0x3e>

0000000000000268 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26e:	02b57463          	bgeu	a0,a1,296 <memmove+0x2e>
    while(n-- > 0)
 272:	00c05f63          	blez	a2,290 <memmove+0x28>
 276:	1602                	slli	a2,a2,0x20
 278:	9201                	srli	a2,a2,0x20
 27a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27e:	872a                	mv	a4,a0
      *dst++ = *src++;
 280:	0585                	addi	a1,a1,1
 282:	0705                	addi	a4,a4,1
 284:	fff5c683          	lbu	a3,-1(a1)
 288:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28c:	fef71ae3          	bne	a4,a5,280 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
    dst += n;
 296:	00c50733          	add	a4,a0,a2
    src += n;
 29a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 29c:	fec05ae3          	blez	a2,290 <memmove+0x28>
 2a0:	fff6079b          	addiw	a5,a2,-1
 2a4:	1782                	slli	a5,a5,0x20
 2a6:	9381                	srli	a5,a5,0x20
 2a8:	fff7c793          	not	a5,a5
 2ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ae:	15fd                	addi	a1,a1,-1
 2b0:	177d                	addi	a4,a4,-1
 2b2:	0005c683          	lbu	a3,0(a1)
 2b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ba:	fee79ae3          	bne	a5,a4,2ae <memmove+0x46>
 2be:	bfc9                	j	290 <memmove+0x28>

00000000000002c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c6:	ca05                	beqz	a2,2f6 <memcmp+0x36>
 2c8:	fff6069b          	addiw	a3,a2,-1
 2cc:	1682                	slli	a3,a3,0x20
 2ce:	9281                	srli	a3,a3,0x20
 2d0:	0685                	addi	a3,a3,1
 2d2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	0005c703          	lbu	a4,0(a1)
 2dc:	00e79863          	bne	a5,a4,2ec <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2e0:	0505                	addi	a0,a0,1
    p2++;
 2e2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e4:	fed518e3          	bne	a0,a3,2d4 <memcmp+0x14>
  }
  return 0;
 2e8:	4501                	li	a0,0
 2ea:	a019                	j	2f0 <memcmp+0x30>
      return *p1 - *p2;
 2ec:	40e7853b          	subw	a0,a5,a4
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  return 0;
 2f6:	4501                	li	a0,0
 2f8:	bfe5                	j	2f0 <memcmp+0x30>

00000000000002fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 302:	00000097          	auipc	ra,0x0
 306:	f66080e7          	jalr	-154(ra) # 268 <memmove>
}
 30a:	60a2                	ld	ra,8(sp)
 30c:	6402                	ld	s0,0(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret

0000000000000312 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 312:	4885                	li	a7,1
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <exit>:
.global exit
exit:
 li a7, SYS_exit
 31a:	4889                	li	a7,2
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <wait>:
.global wait
wait:
 li a7, SYS_wait
 322:	488d                	li	a7,3
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32a:	4891                	li	a7,4
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <read>:
.global read
read:
 li a7, SYS_read
 332:	4895                	li	a7,5
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <write>:
.global write
write:
 li a7, SYS_write
 33a:	48c1                	li	a7,16
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <close>:
.global close
close:
 li a7, SYS_close
 342:	48d5                	li	a7,21
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <kill>:
.global kill
kill:
 li a7, SYS_kill
 34a:	4899                	li	a7,6
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <exec>:
.global exec
exec:
 li a7, SYS_exec
 352:	489d                	li	a7,7
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <open>:
.global open
open:
 li a7, SYS_open
 35a:	48bd                	li	a7,15
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 362:	48c5                	li	a7,17
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36a:	48c9                	li	a7,18
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 372:	48a1                	li	a7,8
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <link>:
.global link
link:
 li a7, SYS_link
 37a:	48cd                	li	a7,19
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 382:	48d1                	li	a7,20
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38a:	48a5                	li	a7,9
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <dup>:
.global dup
dup:
 li a7, SYS_dup
 392:	48a9                	li	a7,10
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39a:	48ad                	li	a7,11
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a2:	48b1                	li	a7,12
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3aa:	48b5                	li	a7,13
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b2:	48b9                	li	a7,14
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <yield>:
.global yield
yield:
 li a7, SYS_yield
 3ba:	48d9                	li	a7,22
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <lock>:
.global lock
lock:
 li a7, SYS_lock
 3c2:	48dd                	li	a7,23
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 3ca:	48e1                	li	a7,24
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3de:	4605                	li	a2,1
 3e0:	fef40593          	addi	a1,s0,-17
 3e4:	00000097          	auipc	ra,0x0
 3e8:	f56080e7          	jalr	-170(ra) # 33a <write>
}
 3ec:	60e2                	ld	ra,24(sp)
 3ee:	6442                	ld	s0,16(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f4:	7139                	addi	sp,sp,-64
 3f6:	fc06                	sd	ra,56(sp)
 3f8:	f822                	sd	s0,48(sp)
 3fa:	f426                	sd	s1,40(sp)
 3fc:	0080                	addi	s0,sp,64
 3fe:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 400:	c299                	beqz	a3,406 <printint+0x12>
 402:	0805cb63          	bltz	a1,498 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 406:	2581                	sext.w	a1,a1
  neg = 0;
 408:	4881                	li	a7,0
 40a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 40e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 410:	2601                	sext.w	a2,a2
 412:	00000517          	auipc	a0,0x0
 416:	68e50513          	addi	a0,a0,1678 # aa0 <digits>
 41a:	883a                	mv	a6,a4
 41c:	2705                	addiw	a4,a4,1
 41e:	02c5f7bb          	remuw	a5,a1,a2
 422:	1782                	slli	a5,a5,0x20
 424:	9381                	srli	a5,a5,0x20
 426:	97aa                	add	a5,a5,a0
 428:	0007c783          	lbu	a5,0(a5)
 42c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 430:	0005879b          	sext.w	a5,a1
 434:	02c5d5bb          	divuw	a1,a1,a2
 438:	0685                	addi	a3,a3,1
 43a:	fec7f0e3          	bgeu	a5,a2,41a <printint+0x26>
  if(neg)
 43e:	00088c63          	beqz	a7,456 <printint+0x62>
    buf[i++] = '-';
 442:	fd070793          	addi	a5,a4,-48
 446:	00878733          	add	a4,a5,s0
 44a:	02d00793          	li	a5,45
 44e:	fef70823          	sb	a5,-16(a4)
 452:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 456:	02e05c63          	blez	a4,48e <printint+0x9a>
 45a:	f04a                	sd	s2,32(sp)
 45c:	ec4e                	sd	s3,24(sp)
 45e:	fc040793          	addi	a5,s0,-64
 462:	00e78933          	add	s2,a5,a4
 466:	fff78993          	addi	s3,a5,-1
 46a:	99ba                	add	s3,s3,a4
 46c:	377d                	addiw	a4,a4,-1
 46e:	1702                	slli	a4,a4,0x20
 470:	9301                	srli	a4,a4,0x20
 472:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 476:	fff94583          	lbu	a1,-1(s2)
 47a:	8526                	mv	a0,s1
 47c:	00000097          	auipc	ra,0x0
 480:	f56080e7          	jalr	-170(ra) # 3d2 <putc>
  while(--i >= 0)
 484:	197d                	addi	s2,s2,-1
 486:	ff3918e3          	bne	s2,s3,476 <printint+0x82>
 48a:	7902                	ld	s2,32(sp)
 48c:	69e2                	ld	s3,24(sp)
}
 48e:	70e2                	ld	ra,56(sp)
 490:	7442                	ld	s0,48(sp)
 492:	74a2                	ld	s1,40(sp)
 494:	6121                	addi	sp,sp,64
 496:	8082                	ret
    x = -xx;
 498:	40b005bb          	negw	a1,a1
    neg = 1;
 49c:	4885                	li	a7,1
    x = -xx;
 49e:	b7b5                	j	40a <printint+0x16>

00000000000004a0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a0:	715d                	addi	sp,sp,-80
 4a2:	e486                	sd	ra,72(sp)
 4a4:	e0a2                	sd	s0,64(sp)
 4a6:	f84a                	sd	s2,48(sp)
 4a8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4aa:	0005c903          	lbu	s2,0(a1)
 4ae:	1a090a63          	beqz	s2,662 <vprintf+0x1c2>
 4b2:	fc26                	sd	s1,56(sp)
 4b4:	f44e                	sd	s3,40(sp)
 4b6:	f052                	sd	s4,32(sp)
 4b8:	ec56                	sd	s5,24(sp)
 4ba:	e85a                	sd	s6,16(sp)
 4bc:	e45e                	sd	s7,8(sp)
 4be:	8aaa                	mv	s5,a0
 4c0:	8bb2                	mv	s7,a2
 4c2:	00158493          	addi	s1,a1,1
  state = 0;
 4c6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c8:	02500a13          	li	s4,37
 4cc:	4b55                	li	s6,21
 4ce:	a839                	j	4ec <vprintf+0x4c>
        putc(fd, c);
 4d0:	85ca                	mv	a1,s2
 4d2:	8556                	mv	a0,s5
 4d4:	00000097          	auipc	ra,0x0
 4d8:	efe080e7          	jalr	-258(ra) # 3d2 <putc>
 4dc:	a019                	j	4e2 <vprintf+0x42>
    } else if(state == '%'){
 4de:	01498d63          	beq	s3,s4,4f8 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4e2:	0485                	addi	s1,s1,1
 4e4:	fff4c903          	lbu	s2,-1(s1)
 4e8:	16090763          	beqz	s2,656 <vprintf+0x1b6>
    if(state == 0){
 4ec:	fe0999e3          	bnez	s3,4de <vprintf+0x3e>
      if(c == '%'){
 4f0:	ff4910e3          	bne	s2,s4,4d0 <vprintf+0x30>
        state = '%';
 4f4:	89d2                	mv	s3,s4
 4f6:	b7f5                	j	4e2 <vprintf+0x42>
      if(c == 'd'){
 4f8:	13490463          	beq	s2,s4,620 <vprintf+0x180>
 4fc:	f9d9079b          	addiw	a5,s2,-99
 500:	0ff7f793          	zext.b	a5,a5
 504:	12fb6763          	bltu	s6,a5,632 <vprintf+0x192>
 508:	f9d9079b          	addiw	a5,s2,-99
 50c:	0ff7f713          	zext.b	a4,a5
 510:	12eb6163          	bltu	s6,a4,632 <vprintf+0x192>
 514:	00271793          	slli	a5,a4,0x2
 518:	00000717          	auipc	a4,0x0
 51c:	53070713          	addi	a4,a4,1328 # a48 <malloc+0x1c0>
 520:	97ba                	add	a5,a5,a4
 522:	439c                	lw	a5,0(a5)
 524:	97ba                	add	a5,a5,a4
 526:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 528:	008b8913          	addi	s2,s7,8
 52c:	4685                	li	a3,1
 52e:	4629                	li	a2,10
 530:	000ba583          	lw	a1,0(s7)
 534:	8556                	mv	a0,s5
 536:	00000097          	auipc	ra,0x0
 53a:	ebe080e7          	jalr	-322(ra) # 3f4 <printint>
 53e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 540:	4981                	li	s3,0
 542:	b745                	j	4e2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 544:	008b8913          	addi	s2,s7,8
 548:	4681                	li	a3,0
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	ea2080e7          	jalr	-350(ra) # 3f4 <printint>
 55a:	8bca                	mv	s7,s2
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b751                	j	4e2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 560:	008b8913          	addi	s2,s7,8
 564:	4681                	li	a3,0
 566:	4641                	li	a2,16
 568:	000ba583          	lw	a1,0(s7)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	e86080e7          	jalr	-378(ra) # 3f4 <printint>
 576:	8bca                	mv	s7,s2
      state = 0;
 578:	4981                	li	s3,0
 57a:	b7a5                	j	4e2 <vprintf+0x42>
 57c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 57e:	008b8c13          	addi	s8,s7,8
 582:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 586:	03000593          	li	a1,48
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e46080e7          	jalr	-442(ra) # 3d2 <putc>
  putc(fd, 'x');
 594:	07800593          	li	a1,120
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	e38080e7          	jalr	-456(ra) # 3d2 <putc>
 5a2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a4:	00000b97          	auipc	s7,0x0
 5a8:	4fcb8b93          	addi	s7,s7,1276 # aa0 <digits>
 5ac:	03c9d793          	srli	a5,s3,0x3c
 5b0:	97de                	add	a5,a5,s7
 5b2:	0007c583          	lbu	a1,0(a5)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e1a080e7          	jalr	-486(ra) # 3d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c0:	0992                	slli	s3,s3,0x4
 5c2:	397d                	addiw	s2,s2,-1
 5c4:	fe0914e3          	bnez	s2,5ac <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5c8:	8be2                	mv	s7,s8
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	6c02                	ld	s8,0(sp)
 5ce:	bf11                	j	4e2 <vprintf+0x42>
        s = va_arg(ap, char*);
 5d0:	008b8993          	addi	s3,s7,8
 5d4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5d8:	02090163          	beqz	s2,5fa <vprintf+0x15a>
        while(*s != 0){
 5dc:	00094583          	lbu	a1,0(s2)
 5e0:	c9a5                	beqz	a1,650 <vprintf+0x1b0>
          putc(fd, *s);
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	dee080e7          	jalr	-530(ra) # 3d2 <putc>
          s++;
 5ec:	0905                	addi	s2,s2,1
        while(*s != 0){
 5ee:	00094583          	lbu	a1,0(s2)
 5f2:	f9e5                	bnez	a1,5e2 <vprintf+0x142>
        s = va_arg(ap, char*);
 5f4:	8bce                	mv	s7,s3
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b5ed                	j	4e2 <vprintf+0x42>
          s = "(null)";
 5fa:	00000917          	auipc	s2,0x0
 5fe:	44690913          	addi	s2,s2,1094 # a40 <malloc+0x1b8>
        while(*s != 0){
 602:	02800593          	li	a1,40
 606:	bff1                	j	5e2 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 608:	008b8913          	addi	s2,s7,8
 60c:	000bc583          	lbu	a1,0(s7)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	dc0080e7          	jalr	-576(ra) # 3d2 <putc>
 61a:	8bca                	mv	s7,s2
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b5d1                	j	4e2 <vprintf+0x42>
        putc(fd, c);
 620:	02500593          	li	a1,37
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	dac080e7          	jalr	-596(ra) # 3d2 <putc>
      state = 0;
 62e:	4981                	li	s3,0
 630:	bd4d                	j	4e2 <vprintf+0x42>
        putc(fd, '%');
 632:	02500593          	li	a1,37
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	d9a080e7          	jalr	-614(ra) # 3d2 <putc>
        putc(fd, c);
 640:	85ca                	mv	a1,s2
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	d8e080e7          	jalr	-626(ra) # 3d2 <putc>
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bd51                	j	4e2 <vprintf+0x42>
        s = va_arg(ap, char*);
 650:	8bce                	mv	s7,s3
      state = 0;
 652:	4981                	li	s3,0
 654:	b579                	j	4e2 <vprintf+0x42>
 656:	74e2                	ld	s1,56(sp)
 658:	79a2                	ld	s3,40(sp)
 65a:	7a02                	ld	s4,32(sp)
 65c:	6ae2                	ld	s5,24(sp)
 65e:	6b42                	ld	s6,16(sp)
 660:	6ba2                	ld	s7,8(sp)
    }
  }
}
 662:	60a6                	ld	ra,72(sp)
 664:	6406                	ld	s0,64(sp)
 666:	7942                	ld	s2,48(sp)
 668:	6161                	addi	sp,sp,80
 66a:	8082                	ret

000000000000066c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 66c:	715d                	addi	sp,sp,-80
 66e:	ec06                	sd	ra,24(sp)
 670:	e822                	sd	s0,16(sp)
 672:	1000                	addi	s0,sp,32
 674:	e010                	sd	a2,0(s0)
 676:	e414                	sd	a3,8(s0)
 678:	e818                	sd	a4,16(s0)
 67a:	ec1c                	sd	a5,24(s0)
 67c:	03043023          	sd	a6,32(s0)
 680:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 684:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 688:	8622                	mv	a2,s0
 68a:	00000097          	auipc	ra,0x0
 68e:	e16080e7          	jalr	-490(ra) # 4a0 <vprintf>
}
 692:	60e2                	ld	ra,24(sp)
 694:	6442                	ld	s0,16(sp)
 696:	6161                	addi	sp,sp,80
 698:	8082                	ret

000000000000069a <printf>:

void
printf(const char *fmt, ...)
{
 69a:	7159                	addi	sp,sp,-112
 69c:	f406                	sd	ra,40(sp)
 69e:	f022                	sd	s0,32(sp)
 6a0:	ec26                	sd	s1,24(sp)
 6a2:	1800                	addi	s0,sp,48
 6a4:	84aa                	mv	s1,a0
 6a6:	e40c                	sd	a1,8(s0)
 6a8:	e810                	sd	a2,16(s0)
 6aa:	ec14                	sd	a3,24(s0)
 6ac:	f018                	sd	a4,32(s0)
 6ae:	f41c                	sd	a5,40(s0)
 6b0:	03043823          	sd	a6,48(s0)
 6b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 6b8:	00000097          	auipc	ra,0x0
 6bc:	d0a080e7          	jalr	-758(ra) # 3c2 <lock>
  va_start(ap, fmt);
 6c0:	00840613          	addi	a2,s0,8
 6c4:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 6c8:	85a6                	mv	a1,s1
 6ca:	4505                	li	a0,1
 6cc:	00000097          	auipc	ra,0x0
 6d0:	dd4080e7          	jalr	-556(ra) # 4a0 <vprintf>
  unlock();
 6d4:	00000097          	auipc	ra,0x0
 6d8:	cf6080e7          	jalr	-778(ra) # 3ca <unlock>
}
 6dc:	70a2                	ld	ra,40(sp)
 6de:	7402                	ld	s0,32(sp)
 6e0:	64e2                	ld	s1,24(sp)
 6e2:	6165                	addi	sp,sp,112
 6e4:	8082                	ret

00000000000006e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e6:	7179                	addi	sp,sp,-48
 6e8:	f422                	sd	s0,40(sp)
 6ea:	1800                	addi	s0,sp,48
 6ec:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f0:	fd843783          	ld	a5,-40(s0)
 6f4:	17c1                	addi	a5,a5,-16
 6f6:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	00001797          	auipc	a5,0x1
 6fe:	cd678793          	addi	a5,a5,-810 # 13d0 <freep>
 702:	639c                	ld	a5,0(a5)
 704:	fef43423          	sd	a5,-24(s0)
 708:	a815                	j	73c <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	fe843783          	ld	a5,-24(s0)
 70e:	639c                	ld	a5,0(a5)
 710:	fe843703          	ld	a4,-24(s0)
 714:	00f76f63          	bltu	a4,a5,732 <free+0x4c>
 718:	fe043703          	ld	a4,-32(s0)
 71c:	fe843783          	ld	a5,-24(s0)
 720:	02e7eb63          	bltu	a5,a4,756 <free+0x70>
 724:	fe843783          	ld	a5,-24(s0)
 728:	639c                	ld	a5,0(a5)
 72a:	fe043703          	ld	a4,-32(s0)
 72e:	02f76463          	bltu	a4,a5,756 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 732:	fe843783          	ld	a5,-24(s0)
 736:	639c                	ld	a5,0(a5)
 738:	fef43423          	sd	a5,-24(s0)
 73c:	fe043703          	ld	a4,-32(s0)
 740:	fe843783          	ld	a5,-24(s0)
 744:	fce7f3e3          	bgeu	a5,a4,70a <free+0x24>
 748:	fe843783          	ld	a5,-24(s0)
 74c:	639c                	ld	a5,0(a5)
 74e:	fe043703          	ld	a4,-32(s0)
 752:	faf77ce3          	bgeu	a4,a5,70a <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 756:	fe043783          	ld	a5,-32(s0)
 75a:	479c                	lw	a5,8(a5)
 75c:	1782                	slli	a5,a5,0x20
 75e:	9381                	srli	a5,a5,0x20
 760:	0792                	slli	a5,a5,0x4
 762:	fe043703          	ld	a4,-32(s0)
 766:	973e                	add	a4,a4,a5
 768:	fe843783          	ld	a5,-24(s0)
 76c:	639c                	ld	a5,0(a5)
 76e:	02f71763          	bne	a4,a5,79c <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 772:	fe043783          	ld	a5,-32(s0)
 776:	4798                	lw	a4,8(a5)
 778:	fe843783          	ld	a5,-24(s0)
 77c:	639c                	ld	a5,0(a5)
 77e:	479c                	lw	a5,8(a5)
 780:	9fb9                	addw	a5,a5,a4
 782:	0007871b          	sext.w	a4,a5
 786:	fe043783          	ld	a5,-32(s0)
 78a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 78c:	fe843783          	ld	a5,-24(s0)
 790:	639c                	ld	a5,0(a5)
 792:	6398                	ld	a4,0(a5)
 794:	fe043783          	ld	a5,-32(s0)
 798:	e398                	sd	a4,0(a5)
 79a:	a039                	j	7a8 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 79c:	fe843783          	ld	a5,-24(s0)
 7a0:	6398                	ld	a4,0(a5)
 7a2:	fe043783          	ld	a5,-32(s0)
 7a6:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 7a8:	fe843783          	ld	a5,-24(s0)
 7ac:	479c                	lw	a5,8(a5)
 7ae:	1782                	slli	a5,a5,0x20
 7b0:	9381                	srli	a5,a5,0x20
 7b2:	0792                	slli	a5,a5,0x4
 7b4:	fe843703          	ld	a4,-24(s0)
 7b8:	97ba                	add	a5,a5,a4
 7ba:	fe043703          	ld	a4,-32(s0)
 7be:	02f71563          	bne	a4,a5,7e8 <free+0x102>
    p->s.size += bp->s.size;
 7c2:	fe843783          	ld	a5,-24(s0)
 7c6:	4798                	lw	a4,8(a5)
 7c8:	fe043783          	ld	a5,-32(s0)
 7cc:	479c                	lw	a5,8(a5)
 7ce:	9fb9                	addw	a5,a5,a4
 7d0:	0007871b          	sext.w	a4,a5
 7d4:	fe843783          	ld	a5,-24(s0)
 7d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7da:	fe043783          	ld	a5,-32(s0)
 7de:	6398                	ld	a4,0(a5)
 7e0:	fe843783          	ld	a5,-24(s0)
 7e4:	e398                	sd	a4,0(a5)
 7e6:	a031                	j	7f2 <free+0x10c>
  } else
    p->s.ptr = bp;
 7e8:	fe843783          	ld	a5,-24(s0)
 7ec:	fe043703          	ld	a4,-32(s0)
 7f0:	e398                	sd	a4,0(a5)
  freep = p;
 7f2:	00001797          	auipc	a5,0x1
 7f6:	bde78793          	addi	a5,a5,-1058 # 13d0 <freep>
 7fa:	fe843703          	ld	a4,-24(s0)
 7fe:	e398                	sd	a4,0(a5)
}
 800:	0001                	nop
 802:	7422                	ld	s0,40(sp)
 804:	6145                	addi	sp,sp,48
 806:	8082                	ret

0000000000000808 <morecore>:

static Header*
morecore(uint nu)
{
 808:	7179                	addi	sp,sp,-48
 80a:	f406                	sd	ra,40(sp)
 80c:	f022                	sd	s0,32(sp)
 80e:	1800                	addi	s0,sp,48
 810:	87aa                	mv	a5,a0
 812:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 816:	fdc42783          	lw	a5,-36(s0)
 81a:	0007871b          	sext.w	a4,a5
 81e:	6785                	lui	a5,0x1
 820:	00f77563          	bgeu	a4,a5,82a <morecore+0x22>
    nu = 4096;
 824:	6785                	lui	a5,0x1
 826:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 82a:	fdc42783          	lw	a5,-36(s0)
 82e:	0047979b          	slliw	a5,a5,0x4
 832:	2781                	sext.w	a5,a5
 834:	2781                	sext.w	a5,a5
 836:	853e                	mv	a0,a5
 838:	00000097          	auipc	ra,0x0
 83c:	b6a080e7          	jalr	-1174(ra) # 3a2 <sbrk>
 840:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 844:	fe843703          	ld	a4,-24(s0)
 848:	57fd                	li	a5,-1
 84a:	00f71463          	bne	a4,a5,852 <morecore+0x4a>
    return 0;
 84e:	4781                	li	a5,0
 850:	a03d                	j	87e <morecore+0x76>
  hp = (Header*)p;
 852:	fe843783          	ld	a5,-24(s0)
 856:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 85a:	fe043783          	ld	a5,-32(s0)
 85e:	fdc42703          	lw	a4,-36(s0)
 862:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 864:	fe043783          	ld	a5,-32(s0)
 868:	07c1                	addi	a5,a5,16 # 1010 <digits+0x570>
 86a:	853e                	mv	a0,a5
 86c:	00000097          	auipc	ra,0x0
 870:	e7a080e7          	jalr	-390(ra) # 6e6 <free>
  return freep;
 874:	00001797          	auipc	a5,0x1
 878:	b5c78793          	addi	a5,a5,-1188 # 13d0 <freep>
 87c:	639c                	ld	a5,0(a5)
}
 87e:	853e                	mv	a0,a5
 880:	70a2                	ld	ra,40(sp)
 882:	7402                	ld	s0,32(sp)
 884:	6145                	addi	sp,sp,48
 886:	8082                	ret

0000000000000888 <malloc>:

void*
malloc(uint nbytes)
{
 888:	7139                	addi	sp,sp,-64
 88a:	fc06                	sd	ra,56(sp)
 88c:	f822                	sd	s0,48(sp)
 88e:	0080                	addi	s0,sp,64
 890:	87aa                	mv	a5,a0
 892:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 896:	fcc46783          	lwu	a5,-52(s0)
 89a:	07bd                	addi	a5,a5,15
 89c:	8391                	srli	a5,a5,0x4
 89e:	2781                	sext.w	a5,a5
 8a0:	2785                	addiw	a5,a5,1
 8a2:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 8a6:	00001797          	auipc	a5,0x1
 8aa:	b2a78793          	addi	a5,a5,-1238 # 13d0 <freep>
 8ae:	639c                	ld	a5,0(a5)
 8b0:	fef43023          	sd	a5,-32(s0)
 8b4:	fe043783          	ld	a5,-32(s0)
 8b8:	ef95                	bnez	a5,8f4 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 8ba:	00001797          	auipc	a5,0x1
 8be:	b0678793          	addi	a5,a5,-1274 # 13c0 <base>
 8c2:	fef43023          	sd	a5,-32(s0)
 8c6:	00001797          	auipc	a5,0x1
 8ca:	b0a78793          	addi	a5,a5,-1270 # 13d0 <freep>
 8ce:	fe043703          	ld	a4,-32(s0)
 8d2:	e398                	sd	a4,0(a5)
 8d4:	00001797          	auipc	a5,0x1
 8d8:	afc78793          	addi	a5,a5,-1284 # 13d0 <freep>
 8dc:	6398                	ld	a4,0(a5)
 8de:	00001797          	auipc	a5,0x1
 8e2:	ae278793          	addi	a5,a5,-1310 # 13c0 <base>
 8e6:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 8e8:	00001797          	auipc	a5,0x1
 8ec:	ad878793          	addi	a5,a5,-1320 # 13c0 <base>
 8f0:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f4:	fe043783          	ld	a5,-32(s0)
 8f8:	639c                	ld	a5,0(a5)
 8fa:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 8fe:	fe843783          	ld	a5,-24(s0)
 902:	4798                	lw	a4,8(a5)
 904:	fdc42783          	lw	a5,-36(s0)
 908:	2781                	sext.w	a5,a5
 90a:	06f76763          	bltu	a4,a5,978 <malloc+0xf0>
      if(p->s.size == nunits)
 90e:	fe843783          	ld	a5,-24(s0)
 912:	4798                	lw	a4,8(a5)
 914:	fdc42783          	lw	a5,-36(s0)
 918:	2781                	sext.w	a5,a5
 91a:	00e79963          	bne	a5,a4,92c <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 91e:	fe843783          	ld	a5,-24(s0)
 922:	6398                	ld	a4,0(a5)
 924:	fe043783          	ld	a5,-32(s0)
 928:	e398                	sd	a4,0(a5)
 92a:	a825                	j	962 <malloc+0xda>
      else {
        p->s.size -= nunits;
 92c:	fe843783          	ld	a5,-24(s0)
 930:	479c                	lw	a5,8(a5)
 932:	fdc42703          	lw	a4,-36(s0)
 936:	9f99                	subw	a5,a5,a4
 938:	0007871b          	sext.w	a4,a5
 93c:	fe843783          	ld	a5,-24(s0)
 940:	c798                	sw	a4,8(a5)
        p += p->s.size;
 942:	fe843783          	ld	a5,-24(s0)
 946:	479c                	lw	a5,8(a5)
 948:	1782                	slli	a5,a5,0x20
 94a:	9381                	srli	a5,a5,0x20
 94c:	0792                	slli	a5,a5,0x4
 94e:	fe843703          	ld	a4,-24(s0)
 952:	97ba                	add	a5,a5,a4
 954:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 958:	fe843783          	ld	a5,-24(s0)
 95c:	fdc42703          	lw	a4,-36(s0)
 960:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 962:	00001797          	auipc	a5,0x1
 966:	a6e78793          	addi	a5,a5,-1426 # 13d0 <freep>
 96a:	fe043703          	ld	a4,-32(s0)
 96e:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 970:	fe843783          	ld	a5,-24(s0)
 974:	07c1                	addi	a5,a5,16
 976:	a091                	j	9ba <malloc+0x132>
    }
    if(p == freep)
 978:	00001797          	auipc	a5,0x1
 97c:	a5878793          	addi	a5,a5,-1448 # 13d0 <freep>
 980:	639c                	ld	a5,0(a5)
 982:	fe843703          	ld	a4,-24(s0)
 986:	02f71063          	bne	a4,a5,9a6 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 98a:	fdc42783          	lw	a5,-36(s0)
 98e:	853e                	mv	a0,a5
 990:	00000097          	auipc	ra,0x0
 994:	e78080e7          	jalr	-392(ra) # 808 <morecore>
 998:	fea43423          	sd	a0,-24(s0)
 99c:	fe843783          	ld	a5,-24(s0)
 9a0:	e399                	bnez	a5,9a6 <malloc+0x11e>
        return 0;
 9a2:	4781                	li	a5,0
 9a4:	a819                	j	9ba <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a6:	fe843783          	ld	a5,-24(s0)
 9aa:	fef43023          	sd	a5,-32(s0)
 9ae:	fe843783          	ld	a5,-24(s0)
 9b2:	639c                	ld	a5,0(a5)
 9b4:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 9b8:	b799                	j	8fe <malloc+0x76>
  }
}
 9ba:	853e                	mv	a0,a5
 9bc:	70e2                	ld	ra,56(sp)
 9be:	7442                	ld	s0,48(sp)
 9c0:	6121                	addi	sp,sp,64
 9c2:	8082                	ret
