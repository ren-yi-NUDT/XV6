
user/tests/_fork:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    printf("hello world (pid:%d)\n", (int) getpid());
   a:	00000097          	auipc	ra,0x0
   e:	38e080e7          	jalr	910(ra) # 398 <getpid>
  12:	85aa                	mv	a1,a0
  14:	00001517          	auipc	a0,0x1
  18:	9bc50513          	addi	a0,a0,-1604 # 9d0 <malloc+0x14a>
  1c:	00000097          	auipc	ra,0x0
  20:	67c080e7          	jalr	1660(ra) # 698 <printf>
    int rc = fork();
  24:	00000097          	auipc	ra,0x0
  28:	2ec080e7          	jalr	748(ra) # 310 <fork>
    if (rc < 0) {
  2c:	02054763          	bltz	a0,5a <main+0x5a>
  30:	84aa                	mv	s1,a0
        // fork failed; exit
        printf("fork failed\n");
        exit(1);
    } else if (rc == 0) {
  32:	e129                	bnez	a0,74 <main+0x74>
        // child (new process)
        printf("hello, I am child (pid:%d)\n", (int) getpid());
  34:	00000097          	auipc	ra,0x0
  38:	364080e7          	jalr	868(ra) # 398 <getpid>
  3c:	85aa                	mv	a1,a0
  3e:	00001517          	auipc	a0,0x1
  42:	9c250513          	addi	a0,a0,-1598 # a00 <malloc+0x17a>
  46:	00000097          	auipc	ra,0x0
  4a:	652080e7          	jalr	1618(ra) # 698 <printf>
        // parent goes down this path (original process)
        printf("hello, I am parent of %d (pid:%d)\n",
	       rc, (int) getpid());
    }
    return 0;
}
  4e:	4501                	li	a0,0
  50:	60e2                	ld	ra,24(sp)
  52:	6442                	ld	s0,16(sp)
  54:	64a2                	ld	s1,8(sp)
  56:	6105                	addi	sp,sp,32
  58:	8082                	ret
        printf("fork failed\n");
  5a:	00001517          	auipc	a0,0x1
  5e:	99650513          	addi	a0,a0,-1642 # 9f0 <malloc+0x16a>
  62:	00000097          	auipc	ra,0x0
  66:	636080e7          	jalr	1590(ra) # 698 <printf>
        exit(1);
  6a:	4505                	li	a0,1
  6c:	00000097          	auipc	ra,0x0
  70:	2ac080e7          	jalr	684(ra) # 318 <exit>
        printf("hello, I am parent of %d (pid:%d)\n",
  74:	00000097          	auipc	ra,0x0
  78:	324080e7          	jalr	804(ra) # 398 <getpid>
  7c:	862a                	mv	a2,a0
  7e:	85a6                	mv	a1,s1
  80:	00001517          	auipc	a0,0x1
  84:	9a050513          	addi	a0,a0,-1632 # a20 <malloc+0x19a>
  88:	00000097          	auipc	ra,0x0
  8c:	610080e7          	jalr	1552(ra) # 698 <printf>
  90:	bf7d                	j	4e <main+0x4e>

0000000000000092 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  92:	1141                	addi	sp,sp,-16
  94:	e406                	sd	ra,8(sp)
  96:	e022                	sd	s0,0(sp)
  98:	0800                	addi	s0,sp,16
  extern int main();
  main();
  9a:	00000097          	auipc	ra,0x0
  9e:	f66080e7          	jalr	-154(ra) # 0 <main>
  exit(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	274080e7          	jalr	628(ra) # 318 <exit>

00000000000000ac <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b2:	87aa                	mv	a5,a0
  b4:	0585                	addi	a1,a1,1
  b6:	0785                	addi	a5,a5,1
  b8:	fff5c703          	lbu	a4,-1(a1)
  bc:	fee78fa3          	sb	a4,-1(a5)
  c0:	fb75                	bnez	a4,b4 <strcpy+0x8>
    ;
  return os;
}
  c2:	6422                	ld	s0,8(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e422                	sd	s0,8(sp)
  cc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cb91                	beqz	a5,e6 <strcmp+0x1e>
  d4:	0005c703          	lbu	a4,0(a1)
  d8:	00f71763          	bne	a4,a5,e6 <strcmp+0x1e>
    p++, q++;
  dc:	0505                	addi	a0,a0,1
  de:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	fbe5                	bnez	a5,d4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e6:	0005c503          	lbu	a0,0(a1)
}
  ea:	40a7853b          	subw	a0,a5,a0
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <strlen>:

uint
strlen(const char *s)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cf91                	beqz	a5,11a <strlen+0x26>
 100:	0505                	addi	a0,a0,1
 102:	87aa                	mv	a5,a0
 104:	86be                	mv	a3,a5
 106:	0785                	addi	a5,a5,1
 108:	fff7c703          	lbu	a4,-1(a5)
 10c:	ff65                	bnez	a4,104 <strlen+0x10>
 10e:	40a6853b          	subw	a0,a3,a0
 112:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  for(n = 0; s[n]; n++)
 11a:	4501                	li	a0,0
 11c:	bfe5                	j	114 <strlen+0x20>

000000000000011e <memset>:

void*
memset(void *dst, int c, uint n)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 124:	ca19                	beqz	a2,13a <memset+0x1c>
 126:	87aa                	mv	a5,a0
 128:	1602                	slli	a2,a2,0x20
 12a:	9201                	srli	a2,a2,0x20
 12c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 130:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 134:	0785                	addi	a5,a5,1
 136:	fee79de3          	bne	a5,a4,130 <memset+0x12>
  }
  return dst;
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  for(; *s; s++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cb99                	beqz	a5,160 <strchr+0x20>
    if(*s == c)
 14c:	00f58763          	beq	a1,a5,15a <strchr+0x1a>
  for(; *s; s++)
 150:	0505                	addi	a0,a0,1
 152:	00054783          	lbu	a5,0(a0)
 156:	fbfd                	bnez	a5,14c <strchr+0xc>
      return (char*)s;
  return 0;
 158:	4501                	li	a0,0
}
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	addi	sp,sp,16
 15e:	8082                	ret
  return 0;
 160:	4501                	li	a0,0
 162:	bfe5                	j	15a <strchr+0x1a>

0000000000000164 <gets>:

char*
gets(char *buf, int max)
{
 164:	711d                	addi	sp,sp,-96
 166:	ec86                	sd	ra,88(sp)
 168:	e8a2                	sd	s0,80(sp)
 16a:	e4a6                	sd	s1,72(sp)
 16c:	e0ca                	sd	s2,64(sp)
 16e:	fc4e                	sd	s3,56(sp)
 170:	f852                	sd	s4,48(sp)
 172:	f456                	sd	s5,40(sp)
 174:	f05a                	sd	s6,32(sp)
 176:	ec5e                	sd	s7,24(sp)
 178:	1080                	addi	s0,sp,96
 17a:	8baa                	mv	s7,a0
 17c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17e:	892a                	mv	s2,a0
 180:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 182:	4aa9                	li	s5,10
 184:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 186:	89a6                	mv	s3,s1
 188:	2485                	addiw	s1,s1,1
 18a:	0344d863          	bge	s1,s4,1ba <gets+0x56>
    cc = read(0, &c, 1);
 18e:	4605                	li	a2,1
 190:	faf40593          	addi	a1,s0,-81
 194:	4501                	li	a0,0
 196:	00000097          	auipc	ra,0x0
 19a:	19a080e7          	jalr	410(ra) # 330 <read>
    if(cc < 1)
 19e:	00a05e63          	blez	a0,1ba <gets+0x56>
    buf[i++] = c;
 1a2:	faf44783          	lbu	a5,-81(s0)
 1a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1aa:	01578763          	beq	a5,s5,1b8 <gets+0x54>
 1ae:	0905                	addi	s2,s2,1
 1b0:	fd679be3          	bne	a5,s6,186 <gets+0x22>
    buf[i++] = c;
 1b4:	89a6                	mv	s3,s1
 1b6:	a011                	j	1ba <gets+0x56>
 1b8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1ba:	99de                	add	s3,s3,s7
 1bc:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c0:	855e                	mv	a0,s7
 1c2:	60e6                	ld	ra,88(sp)
 1c4:	6446                	ld	s0,80(sp)
 1c6:	64a6                	ld	s1,72(sp)
 1c8:	6906                	ld	s2,64(sp)
 1ca:	79e2                	ld	s3,56(sp)
 1cc:	7a42                	ld	s4,48(sp)
 1ce:	7aa2                	ld	s5,40(sp)
 1d0:	7b02                	ld	s6,32(sp)
 1d2:	6be2                	ld	s7,24(sp)
 1d4:	6125                	addi	sp,sp,96
 1d6:	8082                	ret

00000000000001d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d8:	1101                	addi	sp,sp,-32
 1da:	ec06                	sd	ra,24(sp)
 1dc:	e822                	sd	s0,16(sp)
 1de:	e04a                	sd	s2,0(sp)
 1e0:	1000                	addi	s0,sp,32
 1e2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e4:	4581                	li	a1,0
 1e6:	00000097          	auipc	ra,0x0
 1ea:	172080e7          	jalr	370(ra) # 358 <open>
  if(fd < 0)
 1ee:	02054663          	bltz	a0,21a <stat+0x42>
 1f2:	e426                	sd	s1,8(sp)
 1f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f6:	85ca                	mv	a1,s2
 1f8:	00000097          	auipc	ra,0x0
 1fc:	178080e7          	jalr	376(ra) # 370 <fstat>
 200:	892a                	mv	s2,a0
  close(fd);
 202:	8526                	mv	a0,s1
 204:	00000097          	auipc	ra,0x0
 208:	13c080e7          	jalr	316(ra) # 340 <close>
  return r;
 20c:	64a2                	ld	s1,8(sp)
}
 20e:	854a                	mv	a0,s2
 210:	60e2                	ld	ra,24(sp)
 212:	6442                	ld	s0,16(sp)
 214:	6902                	ld	s2,0(sp)
 216:	6105                	addi	sp,sp,32
 218:	8082                	ret
    return -1;
 21a:	597d                	li	s2,-1
 21c:	bfcd                	j	20e <stat+0x36>

000000000000021e <atoi>:

int
atoi(const char *s)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 224:	00054683          	lbu	a3,0(a0)
 228:	fd06879b          	addiw	a5,a3,-48
 22c:	0ff7f793          	zext.b	a5,a5
 230:	4625                	li	a2,9
 232:	02f66863          	bltu	a2,a5,262 <atoi+0x44>
 236:	872a                	mv	a4,a0
  n = 0;
 238:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 23a:	0705                	addi	a4,a4,1
 23c:	0025179b          	slliw	a5,a0,0x2
 240:	9fa9                	addw	a5,a5,a0
 242:	0017979b          	slliw	a5,a5,0x1
 246:	9fb5                	addw	a5,a5,a3
 248:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 24c:	00074683          	lbu	a3,0(a4)
 250:	fd06879b          	addiw	a5,a3,-48
 254:	0ff7f793          	zext.b	a5,a5
 258:	fef671e3          	bgeu	a2,a5,23a <atoi+0x1c>
  return n;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
  n = 0;
 262:	4501                	li	a0,0
 264:	bfe5                	j	25c <atoi+0x3e>

0000000000000266 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26c:	02b57463          	bgeu	a0,a1,294 <memmove+0x2e>
    while(n-- > 0)
 270:	00c05f63          	blez	a2,28e <memmove+0x28>
 274:	1602                	slli	a2,a2,0x20
 276:	9201                	srli	a2,a2,0x20
 278:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27c:	872a                	mv	a4,a0
      *dst++ = *src++;
 27e:	0585                	addi	a1,a1,1
 280:	0705                	addi	a4,a4,1
 282:	fff5c683          	lbu	a3,-1(a1)
 286:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28a:	fef71ae3          	bne	a4,a5,27e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
    dst += n;
 294:	00c50733          	add	a4,a0,a2
    src += n;
 298:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 29a:	fec05ae3          	blez	a2,28e <memmove+0x28>
 29e:	fff6079b          	addiw	a5,a2,-1
 2a2:	1782                	slli	a5,a5,0x20
 2a4:	9381                	srli	a5,a5,0x20
 2a6:	fff7c793          	not	a5,a5
 2aa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ac:	15fd                	addi	a1,a1,-1
 2ae:	177d                	addi	a4,a4,-1
 2b0:	0005c683          	lbu	a3,0(a1)
 2b4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b8:	fee79ae3          	bne	a5,a4,2ac <memmove+0x46>
 2bc:	bfc9                	j	28e <memmove+0x28>

00000000000002be <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c4:	ca05                	beqz	a2,2f4 <memcmp+0x36>
 2c6:	fff6069b          	addiw	a3,a2,-1
 2ca:	1682                	slli	a3,a3,0x20
 2cc:	9281                	srli	a3,a3,0x20
 2ce:	0685                	addi	a3,a3,1
 2d0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	0005c703          	lbu	a4,0(a1)
 2da:	00e79863          	bne	a5,a4,2ea <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2de:	0505                	addi	a0,a0,1
    p2++;
 2e0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e2:	fed518e3          	bne	a0,a3,2d2 <memcmp+0x14>
  }
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	a019                	j	2ee <memcmp+0x30>
      return *p1 - *p2;
 2ea:	40e7853b          	subw	a0,a5,a4
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
  return 0;
 2f4:	4501                	li	a0,0
 2f6:	bfe5                	j	2ee <memcmp+0x30>

00000000000002f8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 300:	00000097          	auipc	ra,0x0
 304:	f66080e7          	jalr	-154(ra) # 266 <memmove>
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 310:	4885                	li	a7,1
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <exit>:
.global exit
exit:
 li a7, SYS_exit
 318:	4889                	li	a7,2
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <wait>:
.global wait
wait:
 li a7, SYS_wait
 320:	488d                	li	a7,3
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 328:	4891                	li	a7,4
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <read>:
.global read
read:
 li a7, SYS_read
 330:	4895                	li	a7,5
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <write>:
.global write
write:
 li a7, SYS_write
 338:	48c1                	li	a7,16
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <close>:
.global close
close:
 li a7, SYS_close
 340:	48d5                	li	a7,21
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <kill>:
.global kill
kill:
 li a7, SYS_kill
 348:	4899                	li	a7,6
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <exec>:
.global exec
exec:
 li a7, SYS_exec
 350:	489d                	li	a7,7
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <open>:
.global open
open:
 li a7, SYS_open
 358:	48bd                	li	a7,15
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 360:	48c5                	li	a7,17
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 368:	48c9                	li	a7,18
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 370:	48a1                	li	a7,8
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <link>:
.global link
link:
 li a7, SYS_link
 378:	48cd                	li	a7,19
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 380:	48d1                	li	a7,20
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 388:	48a5                	li	a7,9
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <dup>:
.global dup
dup:
 li a7, SYS_dup
 390:	48a9                	li	a7,10
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 398:	48ad                	li	a7,11
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a0:	48b1                	li	a7,12
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a8:	48b5                	li	a7,13
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b0:	48b9                	li	a7,14
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <yield>:
.global yield
yield:
 li a7, SYS_yield
 3b8:	48d9                	li	a7,22
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <lock>:
.global lock
lock:
 li a7, SYS_lock
 3c0:	48dd                	li	a7,23
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 3c8:	48e1                	li	a7,24
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d0:	1101                	addi	sp,sp,-32
 3d2:	ec06                	sd	ra,24(sp)
 3d4:	e822                	sd	s0,16(sp)
 3d6:	1000                	addi	s0,sp,32
 3d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3dc:	4605                	li	a2,1
 3de:	fef40593          	addi	a1,s0,-17
 3e2:	00000097          	auipc	ra,0x0
 3e6:	f56080e7          	jalr	-170(ra) # 338 <write>
}
 3ea:	60e2                	ld	ra,24(sp)
 3ec:	6442                	ld	s0,16(sp)
 3ee:	6105                	addi	sp,sp,32
 3f0:	8082                	ret

00000000000003f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f2:	7139                	addi	sp,sp,-64
 3f4:	fc06                	sd	ra,56(sp)
 3f6:	f822                	sd	s0,48(sp)
 3f8:	f426                	sd	s1,40(sp)
 3fa:	0080                	addi	s0,sp,64
 3fc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fe:	c299                	beqz	a3,404 <printint+0x12>
 400:	0805cb63          	bltz	a1,496 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 404:	2581                	sext.w	a1,a1
  neg = 0;
 406:	4881                	li	a7,0
 408:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 40c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 40e:	2601                	sext.w	a2,a2
 410:	00000517          	auipc	a0,0x0
 414:	69850513          	addi	a0,a0,1688 # aa8 <digits>
 418:	883a                	mv	a6,a4
 41a:	2705                	addiw	a4,a4,1
 41c:	02c5f7bb          	remuw	a5,a1,a2
 420:	1782                	slli	a5,a5,0x20
 422:	9381                	srli	a5,a5,0x20
 424:	97aa                	add	a5,a5,a0
 426:	0007c783          	lbu	a5,0(a5)
 42a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 42e:	0005879b          	sext.w	a5,a1
 432:	02c5d5bb          	divuw	a1,a1,a2
 436:	0685                	addi	a3,a3,1
 438:	fec7f0e3          	bgeu	a5,a2,418 <printint+0x26>
  if(neg)
 43c:	00088c63          	beqz	a7,454 <printint+0x62>
    buf[i++] = '-';
 440:	fd070793          	addi	a5,a4,-48
 444:	00878733          	add	a4,a5,s0
 448:	02d00793          	li	a5,45
 44c:	fef70823          	sb	a5,-16(a4)
 450:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 454:	02e05c63          	blez	a4,48c <printint+0x9a>
 458:	f04a                	sd	s2,32(sp)
 45a:	ec4e                	sd	s3,24(sp)
 45c:	fc040793          	addi	a5,s0,-64
 460:	00e78933          	add	s2,a5,a4
 464:	fff78993          	addi	s3,a5,-1
 468:	99ba                	add	s3,s3,a4
 46a:	377d                	addiw	a4,a4,-1
 46c:	1702                	slli	a4,a4,0x20
 46e:	9301                	srli	a4,a4,0x20
 470:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 474:	fff94583          	lbu	a1,-1(s2)
 478:	8526                	mv	a0,s1
 47a:	00000097          	auipc	ra,0x0
 47e:	f56080e7          	jalr	-170(ra) # 3d0 <putc>
  while(--i >= 0)
 482:	197d                	addi	s2,s2,-1
 484:	ff3918e3          	bne	s2,s3,474 <printint+0x82>
 488:	7902                	ld	s2,32(sp)
 48a:	69e2                	ld	s3,24(sp)
}
 48c:	70e2                	ld	ra,56(sp)
 48e:	7442                	ld	s0,48(sp)
 490:	74a2                	ld	s1,40(sp)
 492:	6121                	addi	sp,sp,64
 494:	8082                	ret
    x = -xx;
 496:	40b005bb          	negw	a1,a1
    neg = 1;
 49a:	4885                	li	a7,1
    x = -xx;
 49c:	b7b5                	j	408 <printint+0x16>

000000000000049e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 49e:	715d                	addi	sp,sp,-80
 4a0:	e486                	sd	ra,72(sp)
 4a2:	e0a2                	sd	s0,64(sp)
 4a4:	f84a                	sd	s2,48(sp)
 4a6:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a8:	0005c903          	lbu	s2,0(a1)
 4ac:	1a090a63          	beqz	s2,660 <vprintf+0x1c2>
 4b0:	fc26                	sd	s1,56(sp)
 4b2:	f44e                	sd	s3,40(sp)
 4b4:	f052                	sd	s4,32(sp)
 4b6:	ec56                	sd	s5,24(sp)
 4b8:	e85a                	sd	s6,16(sp)
 4ba:	e45e                	sd	s7,8(sp)
 4bc:	8aaa                	mv	s5,a0
 4be:	8bb2                	mv	s7,a2
 4c0:	00158493          	addi	s1,a1,1
  state = 0;
 4c4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c6:	02500a13          	li	s4,37
 4ca:	4b55                	li	s6,21
 4cc:	a839                	j	4ea <vprintf+0x4c>
        putc(fd, c);
 4ce:	85ca                	mv	a1,s2
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	efe080e7          	jalr	-258(ra) # 3d0 <putc>
 4da:	a019                	j	4e0 <vprintf+0x42>
    } else if(state == '%'){
 4dc:	01498d63          	beq	s3,s4,4f6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4e0:	0485                	addi	s1,s1,1
 4e2:	fff4c903          	lbu	s2,-1(s1)
 4e6:	16090763          	beqz	s2,654 <vprintf+0x1b6>
    if(state == 0){
 4ea:	fe0999e3          	bnez	s3,4dc <vprintf+0x3e>
      if(c == '%'){
 4ee:	ff4910e3          	bne	s2,s4,4ce <vprintf+0x30>
        state = '%';
 4f2:	89d2                	mv	s3,s4
 4f4:	b7f5                	j	4e0 <vprintf+0x42>
      if(c == 'd'){
 4f6:	13490463          	beq	s2,s4,61e <vprintf+0x180>
 4fa:	f9d9079b          	addiw	a5,s2,-99
 4fe:	0ff7f793          	zext.b	a5,a5
 502:	12fb6763          	bltu	s6,a5,630 <vprintf+0x192>
 506:	f9d9079b          	addiw	a5,s2,-99
 50a:	0ff7f713          	zext.b	a4,a5
 50e:	12eb6163          	bltu	s6,a4,630 <vprintf+0x192>
 512:	00271793          	slli	a5,a4,0x2
 516:	00000717          	auipc	a4,0x0
 51a:	53a70713          	addi	a4,a4,1338 # a50 <malloc+0x1ca>
 51e:	97ba                	add	a5,a5,a4
 520:	439c                	lw	a5,0(a5)
 522:	97ba                	add	a5,a5,a4
 524:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 526:	008b8913          	addi	s2,s7,8
 52a:	4685                	li	a3,1
 52c:	4629                	li	a2,10
 52e:	000ba583          	lw	a1,0(s7)
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	ebe080e7          	jalr	-322(ra) # 3f2 <printint>
 53c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 53e:	4981                	li	s3,0
 540:	b745                	j	4e0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 542:	008b8913          	addi	s2,s7,8
 546:	4681                	li	a3,0
 548:	4629                	li	a2,10
 54a:	000ba583          	lw	a1,0(s7)
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	ea2080e7          	jalr	-350(ra) # 3f2 <printint>
 558:	8bca                	mv	s7,s2
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b751                	j	4e0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 55e:	008b8913          	addi	s2,s7,8
 562:	4681                	li	a3,0
 564:	4641                	li	a2,16
 566:	000ba583          	lw	a1,0(s7)
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	e86080e7          	jalr	-378(ra) # 3f2 <printint>
 574:	8bca                	mv	s7,s2
      state = 0;
 576:	4981                	li	s3,0
 578:	b7a5                	j	4e0 <vprintf+0x42>
 57a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 57c:	008b8c13          	addi	s8,s7,8
 580:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 584:	03000593          	li	a1,48
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	e46080e7          	jalr	-442(ra) # 3d0 <putc>
  putc(fd, 'x');
 592:	07800593          	li	a1,120
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e38080e7          	jalr	-456(ra) # 3d0 <putc>
 5a0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a2:	00000b97          	auipc	s7,0x0
 5a6:	506b8b93          	addi	s7,s7,1286 # aa8 <digits>
 5aa:	03c9d793          	srli	a5,s3,0x3c
 5ae:	97de                	add	a5,a5,s7
 5b0:	0007c583          	lbu	a1,0(a5)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e1a080e7          	jalr	-486(ra) # 3d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5be:	0992                	slli	s3,s3,0x4
 5c0:	397d                	addiw	s2,s2,-1
 5c2:	fe0914e3          	bnez	s2,5aa <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5c6:	8be2                	mv	s7,s8
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	6c02                	ld	s8,0(sp)
 5cc:	bf11                	j	4e0 <vprintf+0x42>
        s = va_arg(ap, char*);
 5ce:	008b8993          	addi	s3,s7,8
 5d2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5d6:	02090163          	beqz	s2,5f8 <vprintf+0x15a>
        while(*s != 0){
 5da:	00094583          	lbu	a1,0(s2)
 5de:	c9a5                	beqz	a1,64e <vprintf+0x1b0>
          putc(fd, *s);
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	dee080e7          	jalr	-530(ra) # 3d0 <putc>
          s++;
 5ea:	0905                	addi	s2,s2,1
        while(*s != 0){
 5ec:	00094583          	lbu	a1,0(s2)
 5f0:	f9e5                	bnez	a1,5e0 <vprintf+0x142>
        s = va_arg(ap, char*);
 5f2:	8bce                	mv	s7,s3
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b5ed                	j	4e0 <vprintf+0x42>
          s = "(null)";
 5f8:	00000917          	auipc	s2,0x0
 5fc:	45090913          	addi	s2,s2,1104 # a48 <malloc+0x1c2>
        while(*s != 0){
 600:	02800593          	li	a1,40
 604:	bff1                	j	5e0 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 606:	008b8913          	addi	s2,s7,8
 60a:	000bc583          	lbu	a1,0(s7)
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	dc0080e7          	jalr	-576(ra) # 3d0 <putc>
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b5d1                	j	4e0 <vprintf+0x42>
        putc(fd, c);
 61e:	02500593          	li	a1,37
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	dac080e7          	jalr	-596(ra) # 3d0 <putc>
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bd4d                	j	4e0 <vprintf+0x42>
        putc(fd, '%');
 630:	02500593          	li	a1,37
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	d9a080e7          	jalr	-614(ra) # 3d0 <putc>
        putc(fd, c);
 63e:	85ca                	mv	a1,s2
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	d8e080e7          	jalr	-626(ra) # 3d0 <putc>
      state = 0;
 64a:	4981                	li	s3,0
 64c:	bd51                	j	4e0 <vprintf+0x42>
        s = va_arg(ap, char*);
 64e:	8bce                	mv	s7,s3
      state = 0;
 650:	4981                	li	s3,0
 652:	b579                	j	4e0 <vprintf+0x42>
 654:	74e2                	ld	s1,56(sp)
 656:	79a2                	ld	s3,40(sp)
 658:	7a02                	ld	s4,32(sp)
 65a:	6ae2                	ld	s5,24(sp)
 65c:	6b42                	ld	s6,16(sp)
 65e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 660:	60a6                	ld	ra,72(sp)
 662:	6406                	ld	s0,64(sp)
 664:	7942                	ld	s2,48(sp)
 666:	6161                	addi	sp,sp,80
 668:	8082                	ret

000000000000066a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 66a:	715d                	addi	sp,sp,-80
 66c:	ec06                	sd	ra,24(sp)
 66e:	e822                	sd	s0,16(sp)
 670:	1000                	addi	s0,sp,32
 672:	e010                	sd	a2,0(s0)
 674:	e414                	sd	a3,8(s0)
 676:	e818                	sd	a4,16(s0)
 678:	ec1c                	sd	a5,24(s0)
 67a:	03043023          	sd	a6,32(s0)
 67e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 682:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 686:	8622                	mv	a2,s0
 688:	00000097          	auipc	ra,0x0
 68c:	e16080e7          	jalr	-490(ra) # 49e <vprintf>
}
 690:	60e2                	ld	ra,24(sp)
 692:	6442                	ld	s0,16(sp)
 694:	6161                	addi	sp,sp,80
 696:	8082                	ret

0000000000000698 <printf>:

void
printf(const char *fmt, ...)
{
 698:	7159                	addi	sp,sp,-112
 69a:	f406                	sd	ra,40(sp)
 69c:	f022                	sd	s0,32(sp)
 69e:	ec26                	sd	s1,24(sp)
 6a0:	1800                	addi	s0,sp,48
 6a2:	84aa                	mv	s1,a0
 6a4:	e40c                	sd	a1,8(s0)
 6a6:	e810                	sd	a2,16(s0)
 6a8:	ec14                	sd	a3,24(s0)
 6aa:	f018                	sd	a4,32(s0)
 6ac:	f41c                	sd	a5,40(s0)
 6ae:	03043823          	sd	a6,48(s0)
 6b2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 6b6:	00000097          	auipc	ra,0x0
 6ba:	d0a080e7          	jalr	-758(ra) # 3c0 <lock>
  va_start(ap, fmt);
 6be:	00840613          	addi	a2,s0,8
 6c2:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 6c6:	85a6                	mv	a1,s1
 6c8:	4505                	li	a0,1
 6ca:	00000097          	auipc	ra,0x0
 6ce:	dd4080e7          	jalr	-556(ra) # 49e <vprintf>
  unlock();
 6d2:	00000097          	auipc	ra,0x0
 6d6:	cf6080e7          	jalr	-778(ra) # 3c8 <unlock>
}
 6da:	70a2                	ld	ra,40(sp)
 6dc:	7402                	ld	s0,32(sp)
 6de:	64e2                	ld	s1,24(sp)
 6e0:	6165                	addi	sp,sp,112
 6e2:	8082                	ret

00000000000006e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e4:	7179                	addi	sp,sp,-48
 6e6:	f422                	sd	s0,40(sp)
 6e8:	1800                	addi	s0,sp,48
 6ea:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ee:	fd843783          	ld	a5,-40(s0)
 6f2:	17c1                	addi	a5,a5,-16
 6f4:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f8:	00001797          	auipc	a5,0x1
 6fc:	cd878793          	addi	a5,a5,-808 # 13d0 <freep>
 700:	639c                	ld	a5,0(a5)
 702:	fef43423          	sd	a5,-24(s0)
 706:	a815                	j	73a <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	fe843783          	ld	a5,-24(s0)
 70c:	639c                	ld	a5,0(a5)
 70e:	fe843703          	ld	a4,-24(s0)
 712:	00f76f63          	bltu	a4,a5,730 <free+0x4c>
 716:	fe043703          	ld	a4,-32(s0)
 71a:	fe843783          	ld	a5,-24(s0)
 71e:	02e7eb63          	bltu	a5,a4,754 <free+0x70>
 722:	fe843783          	ld	a5,-24(s0)
 726:	639c                	ld	a5,0(a5)
 728:	fe043703          	ld	a4,-32(s0)
 72c:	02f76463          	bltu	a4,a5,754 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	fe843783          	ld	a5,-24(s0)
 734:	639c                	ld	a5,0(a5)
 736:	fef43423          	sd	a5,-24(s0)
 73a:	fe043703          	ld	a4,-32(s0)
 73e:	fe843783          	ld	a5,-24(s0)
 742:	fce7f3e3          	bgeu	a5,a4,708 <free+0x24>
 746:	fe843783          	ld	a5,-24(s0)
 74a:	639c                	ld	a5,0(a5)
 74c:	fe043703          	ld	a4,-32(s0)
 750:	faf77ce3          	bgeu	a4,a5,708 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 754:	fe043783          	ld	a5,-32(s0)
 758:	479c                	lw	a5,8(a5)
 75a:	1782                	slli	a5,a5,0x20
 75c:	9381                	srli	a5,a5,0x20
 75e:	0792                	slli	a5,a5,0x4
 760:	fe043703          	ld	a4,-32(s0)
 764:	973e                	add	a4,a4,a5
 766:	fe843783          	ld	a5,-24(s0)
 76a:	639c                	ld	a5,0(a5)
 76c:	02f71763          	bne	a4,a5,79a <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 770:	fe043783          	ld	a5,-32(s0)
 774:	4798                	lw	a4,8(a5)
 776:	fe843783          	ld	a5,-24(s0)
 77a:	639c                	ld	a5,0(a5)
 77c:	479c                	lw	a5,8(a5)
 77e:	9fb9                	addw	a5,a5,a4
 780:	0007871b          	sext.w	a4,a5
 784:	fe043783          	ld	a5,-32(s0)
 788:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	fe843783          	ld	a5,-24(s0)
 78e:	639c                	ld	a5,0(a5)
 790:	6398                	ld	a4,0(a5)
 792:	fe043783          	ld	a5,-32(s0)
 796:	e398                	sd	a4,0(a5)
 798:	a039                	j	7a6 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 79a:	fe843783          	ld	a5,-24(s0)
 79e:	6398                	ld	a4,0(a5)
 7a0:	fe043783          	ld	a5,-32(s0)
 7a4:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 7a6:	fe843783          	ld	a5,-24(s0)
 7aa:	479c                	lw	a5,8(a5)
 7ac:	1782                	slli	a5,a5,0x20
 7ae:	9381                	srli	a5,a5,0x20
 7b0:	0792                	slli	a5,a5,0x4
 7b2:	fe843703          	ld	a4,-24(s0)
 7b6:	97ba                	add	a5,a5,a4
 7b8:	fe043703          	ld	a4,-32(s0)
 7bc:	02f71563          	bne	a4,a5,7e6 <free+0x102>
    p->s.size += bp->s.size;
 7c0:	fe843783          	ld	a5,-24(s0)
 7c4:	4798                	lw	a4,8(a5)
 7c6:	fe043783          	ld	a5,-32(s0)
 7ca:	479c                	lw	a5,8(a5)
 7cc:	9fb9                	addw	a5,a5,a4
 7ce:	0007871b          	sext.w	a4,a5
 7d2:	fe843783          	ld	a5,-24(s0)
 7d6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d8:	fe043783          	ld	a5,-32(s0)
 7dc:	6398                	ld	a4,0(a5)
 7de:	fe843783          	ld	a5,-24(s0)
 7e2:	e398                	sd	a4,0(a5)
 7e4:	a031                	j	7f0 <free+0x10c>
  } else
    p->s.ptr = bp;
 7e6:	fe843783          	ld	a5,-24(s0)
 7ea:	fe043703          	ld	a4,-32(s0)
 7ee:	e398                	sd	a4,0(a5)
  freep = p;
 7f0:	00001797          	auipc	a5,0x1
 7f4:	be078793          	addi	a5,a5,-1056 # 13d0 <freep>
 7f8:	fe843703          	ld	a4,-24(s0)
 7fc:	e398                	sd	a4,0(a5)
}
 7fe:	0001                	nop
 800:	7422                	ld	s0,40(sp)
 802:	6145                	addi	sp,sp,48
 804:	8082                	ret

0000000000000806 <morecore>:

static Header*
morecore(uint nu)
{
 806:	7179                	addi	sp,sp,-48
 808:	f406                	sd	ra,40(sp)
 80a:	f022                	sd	s0,32(sp)
 80c:	1800                	addi	s0,sp,48
 80e:	87aa                	mv	a5,a0
 810:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 814:	fdc42783          	lw	a5,-36(s0)
 818:	0007871b          	sext.w	a4,a5
 81c:	6785                	lui	a5,0x1
 81e:	00f77563          	bgeu	a4,a5,828 <morecore+0x22>
    nu = 4096;
 822:	6785                	lui	a5,0x1
 824:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 828:	fdc42783          	lw	a5,-36(s0)
 82c:	0047979b          	slliw	a5,a5,0x4
 830:	2781                	sext.w	a5,a5
 832:	2781                	sext.w	a5,a5
 834:	853e                	mv	a0,a5
 836:	00000097          	auipc	ra,0x0
 83a:	b6a080e7          	jalr	-1174(ra) # 3a0 <sbrk>
 83e:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 842:	fe843703          	ld	a4,-24(s0)
 846:	57fd                	li	a5,-1
 848:	00f71463          	bne	a4,a5,850 <morecore+0x4a>
    return 0;
 84c:	4781                	li	a5,0
 84e:	a03d                	j	87c <morecore+0x76>
  hp = (Header*)p;
 850:	fe843783          	ld	a5,-24(s0)
 854:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 858:	fe043783          	ld	a5,-32(s0)
 85c:	fdc42703          	lw	a4,-36(s0)
 860:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 862:	fe043783          	ld	a5,-32(s0)
 866:	07c1                	addi	a5,a5,16 # 1010 <digits+0x568>
 868:	853e                	mv	a0,a5
 86a:	00000097          	auipc	ra,0x0
 86e:	e7a080e7          	jalr	-390(ra) # 6e4 <free>
  return freep;
 872:	00001797          	auipc	a5,0x1
 876:	b5e78793          	addi	a5,a5,-1186 # 13d0 <freep>
 87a:	639c                	ld	a5,0(a5)
}
 87c:	853e                	mv	a0,a5
 87e:	70a2                	ld	ra,40(sp)
 880:	7402                	ld	s0,32(sp)
 882:	6145                	addi	sp,sp,48
 884:	8082                	ret

0000000000000886 <malloc>:

void*
malloc(uint nbytes)
{
 886:	7139                	addi	sp,sp,-64
 888:	fc06                	sd	ra,56(sp)
 88a:	f822                	sd	s0,48(sp)
 88c:	0080                	addi	s0,sp,64
 88e:	87aa                	mv	a5,a0
 890:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 894:	fcc46783          	lwu	a5,-52(s0)
 898:	07bd                	addi	a5,a5,15
 89a:	8391                	srli	a5,a5,0x4
 89c:	2781                	sext.w	a5,a5
 89e:	2785                	addiw	a5,a5,1
 8a0:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 8a4:	00001797          	auipc	a5,0x1
 8a8:	b2c78793          	addi	a5,a5,-1236 # 13d0 <freep>
 8ac:	639c                	ld	a5,0(a5)
 8ae:	fef43023          	sd	a5,-32(s0)
 8b2:	fe043783          	ld	a5,-32(s0)
 8b6:	ef95                	bnez	a5,8f2 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 8b8:	00001797          	auipc	a5,0x1
 8bc:	b0878793          	addi	a5,a5,-1272 # 13c0 <base>
 8c0:	fef43023          	sd	a5,-32(s0)
 8c4:	00001797          	auipc	a5,0x1
 8c8:	b0c78793          	addi	a5,a5,-1268 # 13d0 <freep>
 8cc:	fe043703          	ld	a4,-32(s0)
 8d0:	e398                	sd	a4,0(a5)
 8d2:	00001797          	auipc	a5,0x1
 8d6:	afe78793          	addi	a5,a5,-1282 # 13d0 <freep>
 8da:	6398                	ld	a4,0(a5)
 8dc:	00001797          	auipc	a5,0x1
 8e0:	ae478793          	addi	a5,a5,-1308 # 13c0 <base>
 8e4:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 8e6:	00001797          	auipc	a5,0x1
 8ea:	ada78793          	addi	a5,a5,-1318 # 13c0 <base>
 8ee:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	fe043783          	ld	a5,-32(s0)
 8f6:	639c                	ld	a5,0(a5)
 8f8:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 8fc:	fe843783          	ld	a5,-24(s0)
 900:	4798                	lw	a4,8(a5)
 902:	fdc42783          	lw	a5,-36(s0)
 906:	2781                	sext.w	a5,a5
 908:	06f76763          	bltu	a4,a5,976 <malloc+0xf0>
      if(p->s.size == nunits)
 90c:	fe843783          	ld	a5,-24(s0)
 910:	4798                	lw	a4,8(a5)
 912:	fdc42783          	lw	a5,-36(s0)
 916:	2781                	sext.w	a5,a5
 918:	00e79963          	bne	a5,a4,92a <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 91c:	fe843783          	ld	a5,-24(s0)
 920:	6398                	ld	a4,0(a5)
 922:	fe043783          	ld	a5,-32(s0)
 926:	e398                	sd	a4,0(a5)
 928:	a825                	j	960 <malloc+0xda>
      else {
        p->s.size -= nunits;
 92a:	fe843783          	ld	a5,-24(s0)
 92e:	479c                	lw	a5,8(a5)
 930:	fdc42703          	lw	a4,-36(s0)
 934:	9f99                	subw	a5,a5,a4
 936:	0007871b          	sext.w	a4,a5
 93a:	fe843783          	ld	a5,-24(s0)
 93e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 940:	fe843783          	ld	a5,-24(s0)
 944:	479c                	lw	a5,8(a5)
 946:	1782                	slli	a5,a5,0x20
 948:	9381                	srli	a5,a5,0x20
 94a:	0792                	slli	a5,a5,0x4
 94c:	fe843703          	ld	a4,-24(s0)
 950:	97ba                	add	a5,a5,a4
 952:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 956:	fe843783          	ld	a5,-24(s0)
 95a:	fdc42703          	lw	a4,-36(s0)
 95e:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 960:	00001797          	auipc	a5,0x1
 964:	a7078793          	addi	a5,a5,-1424 # 13d0 <freep>
 968:	fe043703          	ld	a4,-32(s0)
 96c:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 96e:	fe843783          	ld	a5,-24(s0)
 972:	07c1                	addi	a5,a5,16
 974:	a091                	j	9b8 <malloc+0x132>
    }
    if(p == freep)
 976:	00001797          	auipc	a5,0x1
 97a:	a5a78793          	addi	a5,a5,-1446 # 13d0 <freep>
 97e:	639c                	ld	a5,0(a5)
 980:	fe843703          	ld	a4,-24(s0)
 984:	02f71063          	bne	a4,a5,9a4 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 988:	fdc42783          	lw	a5,-36(s0)
 98c:	853e                	mv	a0,a5
 98e:	00000097          	auipc	ra,0x0
 992:	e78080e7          	jalr	-392(ra) # 806 <morecore>
 996:	fea43423          	sd	a0,-24(s0)
 99a:	fe843783          	ld	a5,-24(s0)
 99e:	e399                	bnez	a5,9a4 <malloc+0x11e>
        return 0;
 9a0:	4781                	li	a5,0
 9a2:	a819                	j	9b8 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a4:	fe843783          	ld	a5,-24(s0)
 9a8:	fef43023          	sd	a5,-32(s0)
 9ac:	fe843783          	ld	a5,-24(s0)
 9b0:	639c                	ld	a5,0(a5)
 9b2:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 9b6:	b799                	j	8fc <malloc+0x76>
  }
}
 9b8:	853e                	mv	a0,a5
 9ba:	70e2                	ld	ra,56(sp)
 9bc:	7442                	ld	s0,48(sp)
 9be:	6121                	addi	sp,sp,64
 9c0:	8082                	ret
