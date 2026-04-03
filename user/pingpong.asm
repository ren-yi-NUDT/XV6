
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]){
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	0080                	addi	s0,sp,64
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
    int p1[2];
    int p2[2];

    pipe(p1);
  10:	fd840513          	addi	a0,s0,-40
  14:	00000097          	auipc	ra,0x0
  18:	3e6080e7          	jalr	998(ra) # 3fa <pipe>
    pipe(p2);
  1c:	fd040513          	addi	a0,s0,-48
  20:	00000097          	auipc	ra,0x0
  24:	3da080e7          	jalr	986(ra) # 3fa <pipe>

    int pid = fork();
  28:	00000097          	auipc	ra,0x0
  2c:	3ba080e7          	jalr	954(ra) # 3e2 <fork>

    if (pid < 0){
  30:	06054f63          	bltz	a0,ae <main+0xae>
        fprintf(2, "fork failed\n");
        exit(1);
    }
    else if (pid == 0){
  34:	e959                	bnez	a0,ca <main+0xca>
        close(p1[1]);
  36:	fdc42503          	lw	a0,-36(s0)
  3a:	00000097          	auipc	ra,0x0
  3e:	3d8080e7          	jalr	984(ra) # 412 <close>
        close(p2[0]);
  42:	fd042503          	lw	a0,-48(s0)
  46:	00000097          	auipc	ra,0x0
  4a:	3cc080e7          	jalr	972(ra) # 412 <close>

        char buf;

        read(p1[0], &buf, 1);
  4e:	4605                	li	a2,1
  50:	fcf40593          	addi	a1,s0,-49
  54:	fd842503          	lw	a0,-40(s0)
  58:	00000097          	auipc	ra,0x0
  5c:	3aa080e7          	jalr	938(ra) # 402 <read>
        printf("%d: received ping\n", getpid());
  60:	00000097          	auipc	ra,0x0
  64:	40a080e7          	jalr	1034(ra) # 46a <getpid>
  68:	85aa                	mv	a1,a0
  6a:	00001517          	auipc	a0,0x1
  6e:	a4650513          	addi	a0,a0,-1466 # ab0 <malloc+0x158>
  72:	00000097          	auipc	ra,0x0
  76:	6f8080e7          	jalr	1784(ra) # 76a <printf>

        write(p2[1], &buf, 1);
  7a:	4605                	li	a2,1
  7c:	fcf40593          	addi	a1,s0,-49
  80:	fd442503          	lw	a0,-44(s0)
  84:	00000097          	auipc	ra,0x0
  88:	386080e7          	jalr	902(ra) # 40a <write>

        close(p1[0]);
  8c:	fd842503          	lw	a0,-40(s0)
  90:	00000097          	auipc	ra,0x0
  94:	382080e7          	jalr	898(ra) # 412 <close>
        close(p2[1]);
  98:	fd442503          	lw	a0,-44(s0)
  9c:	00000097          	auipc	ra,0x0
  a0:	376080e7          	jalr	886(ra) # 412 <close>
        exit(0);
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	344080e7          	jalr	836(ra) # 3ea <exit>
        fprintf(2, "fork failed\n");
  ae:	00001597          	auipc	a1,0x1
  b2:	9f258593          	addi	a1,a1,-1550 # aa0 <malloc+0x148>
  b6:	4509                	li	a0,2
  b8:	00000097          	auipc	ra,0x0
  bc:	684080e7          	jalr	1668(ra) # 73c <fprintf>
        exit(1);
  c0:	4505                	li	a0,1
  c2:	00000097          	auipc	ra,0x0
  c6:	328080e7          	jalr	808(ra) # 3ea <exit>
    }
    else{
        close(p1[0]);
  ca:	fd842503          	lw	a0,-40(s0)
  ce:	00000097          	auipc	ra,0x0
  d2:	344080e7          	jalr	836(ra) # 412 <close>
        close(p2[1]);
  d6:	fd442503          	lw	a0,-44(s0)
  da:	00000097          	auipc	ra,0x0
  de:	338080e7          	jalr	824(ra) # 412 <close>

        char buf;
        if (argc != 2){
  e2:	4709                	li	a4,2
            buf = 'x';
  e4:	07800793          	li	a5,120
        if (argc != 2){
  e8:	06e48963          	beq	s1,a4,15a <main+0x15a>
  ec:	fcf407a3          	sb	a5,-49(s0)
        } 
        else{
            buf = argv[1][0];
        }

        write(p1[1], &buf, 1);
  f0:	4605                	li	a2,1
  f2:	fcf40593          	addi	a1,s0,-49
  f6:	fdc42503          	lw	a0,-36(s0)
  fa:	00000097          	auipc	ra,0x0
  fe:	310080e7          	jalr	784(ra) # 40a <write>
        read(p2[0], &buf, 1);
 102:	4605                	li	a2,1
 104:	fcf40593          	addi	a1,s0,-49
 108:	fd042503          	lw	a0,-48(s0)
 10c:	00000097          	auipc	ra,0x0
 110:	2f6080e7          	jalr	758(ra) # 402 <read>
        printf("%d: received pong\n", getpid());
 114:	00000097          	auipc	ra,0x0
 118:	356080e7          	jalr	854(ra) # 46a <getpid>
 11c:	85aa                	mv	a1,a0
 11e:	00001517          	auipc	a0,0x1
 122:	9aa50513          	addi	a0,a0,-1622 # ac8 <malloc+0x170>
 126:	00000097          	auipc	ra,0x0
 12a:	644080e7          	jalr	1604(ra) # 76a <printf>

        close(p1[1]);
 12e:	fdc42503          	lw	a0,-36(s0)
 132:	00000097          	auipc	ra,0x0
 136:	2e0080e7          	jalr	736(ra) # 412 <close>
        close(p2[0]);
 13a:	fd042503          	lw	a0,-48(s0)
 13e:	00000097          	auipc	ra,0x0
 142:	2d4080e7          	jalr	724(ra) # 412 <close>
        wait(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2aa080e7          	jalr	682(ra) # 3f2 <wait>

    }
    exit(0);
 150:	4501                	li	a0,0
 152:	00000097          	auipc	ra,0x0
 156:	298080e7          	jalr	664(ra) # 3ea <exit>
            buf = argv[1][0];
 15a:	00893783          	ld	a5,8(s2)
 15e:	0007c783          	lbu	a5,0(a5)
 162:	b769                	j	ec <main+0xec>

0000000000000164 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 164:	1141                	addi	sp,sp,-16
 166:	e406                	sd	ra,8(sp)
 168:	e022                	sd	s0,0(sp)
 16a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 16c:	00000097          	auipc	ra,0x0
 170:	e94080e7          	jalr	-364(ra) # 0 <main>
  exit(0);
 174:	4501                	li	a0,0
 176:	00000097          	auipc	ra,0x0
 17a:	274080e7          	jalr	628(ra) # 3ea <exit>

000000000000017e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 184:	87aa                	mv	a5,a0
 186:	0585                	addi	a1,a1,1
 188:	0785                	addi	a5,a5,1
 18a:	fff5c703          	lbu	a4,-1(a1)
 18e:	fee78fa3          	sb	a4,-1(a5)
 192:	fb75                	bnez	a4,186 <strcpy+0x8>
    ;
  return os;
}
 194:	6422                	ld	s0,8(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e422                	sd	s0,8(sp)
 19e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	cb91                	beqz	a5,1b8 <strcmp+0x1e>
 1a6:	0005c703          	lbu	a4,0(a1)
 1aa:	00f71763          	bne	a4,a5,1b8 <strcmp+0x1e>
    p++, q++;
 1ae:	0505                	addi	a0,a0,1
 1b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	fbe5                	bnez	a5,1a6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1b8:	0005c503          	lbu	a0,0(a1)
}
 1bc:	40a7853b          	subw	a0,a5,a0
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strlen>:

uint
strlen(const char *s)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cf91                	beqz	a5,1ec <strlen+0x26>
 1d2:	0505                	addi	a0,a0,1
 1d4:	87aa                	mv	a5,a0
 1d6:	86be                	mv	a3,a5
 1d8:	0785                	addi	a5,a5,1
 1da:	fff7c703          	lbu	a4,-1(a5)
 1de:	ff65                	bnez	a4,1d6 <strlen+0x10>
 1e0:	40a6853b          	subw	a0,a3,a0
 1e4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret
  for(n = 0; s[n]; n++)
 1ec:	4501                	li	a0,0
 1ee:	bfe5                	j	1e6 <strlen+0x20>

00000000000001f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f6:	ca19                	beqz	a2,20c <memset+0x1c>
 1f8:	87aa                	mv	a5,a0
 1fa:	1602                	slli	a2,a2,0x20
 1fc:	9201                	srli	a2,a2,0x20
 1fe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 202:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 206:	0785                	addi	a5,a5,1
 208:	fee79de3          	bne	a5,a4,202 <memset+0x12>
  }
  return dst;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strchr>:

char*
strchr(const char *s, char c)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  for(; *s; s++)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cb99                	beqz	a5,232 <strchr+0x20>
    if(*s == c)
 21e:	00f58763          	beq	a1,a5,22c <strchr+0x1a>
  for(; *s; s++)
 222:	0505                	addi	a0,a0,1
 224:	00054783          	lbu	a5,0(a0)
 228:	fbfd                	bnez	a5,21e <strchr+0xc>
      return (char*)s;
  return 0;
 22a:	4501                	li	a0,0
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  return 0;
 232:	4501                	li	a0,0
 234:	bfe5                	j	22c <strchr+0x1a>

0000000000000236 <gets>:

char*
gets(char *buf, int max)
{
 236:	711d                	addi	sp,sp,-96
 238:	ec86                	sd	ra,88(sp)
 23a:	e8a2                	sd	s0,80(sp)
 23c:	e4a6                	sd	s1,72(sp)
 23e:	e0ca                	sd	s2,64(sp)
 240:	fc4e                	sd	s3,56(sp)
 242:	f852                	sd	s4,48(sp)
 244:	f456                	sd	s5,40(sp)
 246:	f05a                	sd	s6,32(sp)
 248:	ec5e                	sd	s7,24(sp)
 24a:	1080                	addi	s0,sp,96
 24c:	8baa                	mv	s7,a0
 24e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 250:	892a                	mv	s2,a0
 252:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 254:	4aa9                	li	s5,10
 256:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 258:	89a6                	mv	s3,s1
 25a:	2485                	addiw	s1,s1,1
 25c:	0344d863          	bge	s1,s4,28c <gets+0x56>
    cc = read(0, &c, 1);
 260:	4605                	li	a2,1
 262:	faf40593          	addi	a1,s0,-81
 266:	4501                	li	a0,0
 268:	00000097          	auipc	ra,0x0
 26c:	19a080e7          	jalr	410(ra) # 402 <read>
    if(cc < 1)
 270:	00a05e63          	blez	a0,28c <gets+0x56>
    buf[i++] = c;
 274:	faf44783          	lbu	a5,-81(s0)
 278:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 27c:	01578763          	beq	a5,s5,28a <gets+0x54>
 280:	0905                	addi	s2,s2,1
 282:	fd679be3          	bne	a5,s6,258 <gets+0x22>
    buf[i++] = c;
 286:	89a6                	mv	s3,s1
 288:	a011                	j	28c <gets+0x56>
 28a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 28c:	99de                	add	s3,s3,s7
 28e:	00098023          	sb	zero,0(s3)
  return buf;
}
 292:	855e                	mv	a0,s7
 294:	60e6                	ld	ra,88(sp)
 296:	6446                	ld	s0,80(sp)
 298:	64a6                	ld	s1,72(sp)
 29a:	6906                	ld	s2,64(sp)
 29c:	79e2                	ld	s3,56(sp)
 29e:	7a42                	ld	s4,48(sp)
 2a0:	7aa2                	ld	s5,40(sp)
 2a2:	7b02                	ld	s6,32(sp)
 2a4:	6be2                	ld	s7,24(sp)
 2a6:	6125                	addi	sp,sp,96
 2a8:	8082                	ret

00000000000002aa <stat>:

int
stat(const char *n, struct stat *st)
{
 2aa:	1101                	addi	sp,sp,-32
 2ac:	ec06                	sd	ra,24(sp)
 2ae:	e822                	sd	s0,16(sp)
 2b0:	e04a                	sd	s2,0(sp)
 2b2:	1000                	addi	s0,sp,32
 2b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b6:	4581                	li	a1,0
 2b8:	00000097          	auipc	ra,0x0
 2bc:	172080e7          	jalr	370(ra) # 42a <open>
  if(fd < 0)
 2c0:	02054663          	bltz	a0,2ec <stat+0x42>
 2c4:	e426                	sd	s1,8(sp)
 2c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2c8:	85ca                	mv	a1,s2
 2ca:	00000097          	auipc	ra,0x0
 2ce:	178080e7          	jalr	376(ra) # 442 <fstat>
 2d2:	892a                	mv	s2,a0
  close(fd);
 2d4:	8526                	mv	a0,s1
 2d6:	00000097          	auipc	ra,0x0
 2da:	13c080e7          	jalr	316(ra) # 412 <close>
  return r;
 2de:	64a2                	ld	s1,8(sp)
}
 2e0:	854a                	mv	a0,s2
 2e2:	60e2                	ld	ra,24(sp)
 2e4:	6442                	ld	s0,16(sp)
 2e6:	6902                	ld	s2,0(sp)
 2e8:	6105                	addi	sp,sp,32
 2ea:	8082                	ret
    return -1;
 2ec:	597d                	li	s2,-1
 2ee:	bfcd                	j	2e0 <stat+0x36>

00000000000002f0 <atoi>:

int
atoi(const char *s)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f6:	00054683          	lbu	a3,0(a0)
 2fa:	fd06879b          	addiw	a5,a3,-48
 2fe:	0ff7f793          	zext.b	a5,a5
 302:	4625                	li	a2,9
 304:	02f66863          	bltu	a2,a5,334 <atoi+0x44>
 308:	872a                	mv	a4,a0
  n = 0;
 30a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 30c:	0705                	addi	a4,a4,1
 30e:	0025179b          	slliw	a5,a0,0x2
 312:	9fa9                	addw	a5,a5,a0
 314:	0017979b          	slliw	a5,a5,0x1
 318:	9fb5                	addw	a5,a5,a3
 31a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 31e:	00074683          	lbu	a3,0(a4)
 322:	fd06879b          	addiw	a5,a3,-48
 326:	0ff7f793          	zext.b	a5,a5
 32a:	fef671e3          	bgeu	a2,a5,30c <atoi+0x1c>
  return n;
}
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret
  n = 0;
 334:	4501                	li	a0,0
 336:	bfe5                	j	32e <atoi+0x3e>

0000000000000338 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 33e:	02b57463          	bgeu	a0,a1,366 <memmove+0x2e>
    while(n-- > 0)
 342:	00c05f63          	blez	a2,360 <memmove+0x28>
 346:	1602                	slli	a2,a2,0x20
 348:	9201                	srli	a2,a2,0x20
 34a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 34e:	872a                	mv	a4,a0
      *dst++ = *src++;
 350:	0585                	addi	a1,a1,1
 352:	0705                	addi	a4,a4,1
 354:	fff5c683          	lbu	a3,-1(a1)
 358:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 35c:	fef71ae3          	bne	a4,a5,350 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 360:	6422                	ld	s0,8(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
    dst += n;
 366:	00c50733          	add	a4,a0,a2
    src += n;
 36a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 36c:	fec05ae3          	blez	a2,360 <memmove+0x28>
 370:	fff6079b          	addiw	a5,a2,-1
 374:	1782                	slli	a5,a5,0x20
 376:	9381                	srli	a5,a5,0x20
 378:	fff7c793          	not	a5,a5
 37c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 37e:	15fd                	addi	a1,a1,-1
 380:	177d                	addi	a4,a4,-1
 382:	0005c683          	lbu	a3,0(a1)
 386:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 38a:	fee79ae3          	bne	a5,a4,37e <memmove+0x46>
 38e:	bfc9                	j	360 <memmove+0x28>

0000000000000390 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 390:	1141                	addi	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 396:	ca05                	beqz	a2,3c6 <memcmp+0x36>
 398:	fff6069b          	addiw	a3,a2,-1
 39c:	1682                	slli	a3,a3,0x20
 39e:	9281                	srli	a3,a3,0x20
 3a0:	0685                	addi	a3,a3,1
 3a2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3a4:	00054783          	lbu	a5,0(a0)
 3a8:	0005c703          	lbu	a4,0(a1)
 3ac:	00e79863          	bne	a5,a4,3bc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3b0:	0505                	addi	a0,a0,1
    p2++;
 3b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b4:	fed518e3          	bne	a0,a3,3a4 <memcmp+0x14>
  }
  return 0;
 3b8:	4501                	li	a0,0
 3ba:	a019                	j	3c0 <memcmp+0x30>
      return *p1 - *p2;
 3bc:	40e7853b          	subw	a0,a5,a4
}
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
  return 0;
 3c6:	4501                	li	a0,0
 3c8:	bfe5                	j	3c0 <memcmp+0x30>

00000000000003ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e406                	sd	ra,8(sp)
 3ce:	e022                	sd	s0,0(sp)
 3d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d2:	00000097          	auipc	ra,0x0
 3d6:	f66080e7          	jalr	-154(ra) # 338 <memmove>
}
 3da:	60a2                	ld	ra,8(sp)
 3dc:	6402                	ld	s0,0(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e2:	4885                	li	a7,1
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ea:	4889                	li	a7,2
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f2:	488d                	li	a7,3
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3fa:	4891                	li	a7,4
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <read>:
.global read
read:
 li a7, SYS_read
 402:	4895                	li	a7,5
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <write>:
.global write
write:
 li a7, SYS_write
 40a:	48c1                	li	a7,16
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <close>:
.global close
close:
 li a7, SYS_close
 412:	48d5                	li	a7,21
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <kill>:
.global kill
kill:
 li a7, SYS_kill
 41a:	4899                	li	a7,6
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <exec>:
.global exec
exec:
 li a7, SYS_exec
 422:	489d                	li	a7,7
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <open>:
.global open
open:
 li a7, SYS_open
 42a:	48bd                	li	a7,15
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 432:	48c5                	li	a7,17
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43a:	48c9                	li	a7,18
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 442:	48a1                	li	a7,8
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <link>:
.global link
link:
 li a7, SYS_link
 44a:	48cd                	li	a7,19
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 452:	48d1                	li	a7,20
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 45a:	48a5                	li	a7,9
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <dup>:
.global dup
dup:
 li a7, SYS_dup
 462:	48a9                	li	a7,10
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 46a:	48ad                	li	a7,11
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 472:	48b1                	li	a7,12
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 47a:	48b5                	li	a7,13
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 482:	48b9                	li	a7,14
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <yield>:
.global yield
yield:
 li a7, SYS_yield
 48a:	48d9                	li	a7,22
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <lock>:
.global lock
lock:
 li a7, SYS_lock
 492:	48dd                	li	a7,23
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 49a:	48e1                	li	a7,24
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a2:	1101                	addi	sp,sp,-32
 4a4:	ec06                	sd	ra,24(sp)
 4a6:	e822                	sd	s0,16(sp)
 4a8:	1000                	addi	s0,sp,32
 4aa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ae:	4605                	li	a2,1
 4b0:	fef40593          	addi	a1,s0,-17
 4b4:	00000097          	auipc	ra,0x0
 4b8:	f56080e7          	jalr	-170(ra) # 40a <write>
}
 4bc:	60e2                	ld	ra,24(sp)
 4be:	6442                	ld	s0,16(sp)
 4c0:	6105                	addi	sp,sp,32
 4c2:	8082                	ret

00000000000004c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c4:	7139                	addi	sp,sp,-64
 4c6:	fc06                	sd	ra,56(sp)
 4c8:	f822                	sd	s0,48(sp)
 4ca:	f426                	sd	s1,40(sp)
 4cc:	0080                	addi	s0,sp,64
 4ce:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d0:	c299                	beqz	a3,4d6 <printint+0x12>
 4d2:	0805cb63          	bltz	a1,568 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d6:	2581                	sext.w	a1,a1
  neg = 0;
 4d8:	4881                	li	a7,0
 4da:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4de:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e0:	2601                	sext.w	a2,a2
 4e2:	00000517          	auipc	a0,0x0
 4e6:	65e50513          	addi	a0,a0,1630 # b40 <digits>
 4ea:	883a                	mv	a6,a4
 4ec:	2705                	addiw	a4,a4,1
 4ee:	02c5f7bb          	remuw	a5,a1,a2
 4f2:	1782                	slli	a5,a5,0x20
 4f4:	9381                	srli	a5,a5,0x20
 4f6:	97aa                	add	a5,a5,a0
 4f8:	0007c783          	lbu	a5,0(a5)
 4fc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 500:	0005879b          	sext.w	a5,a1
 504:	02c5d5bb          	divuw	a1,a1,a2
 508:	0685                	addi	a3,a3,1
 50a:	fec7f0e3          	bgeu	a5,a2,4ea <printint+0x26>
  if(neg)
 50e:	00088c63          	beqz	a7,526 <printint+0x62>
    buf[i++] = '-';
 512:	fd070793          	addi	a5,a4,-48
 516:	00878733          	add	a4,a5,s0
 51a:	02d00793          	li	a5,45
 51e:	fef70823          	sb	a5,-16(a4)
 522:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 526:	02e05c63          	blez	a4,55e <printint+0x9a>
 52a:	f04a                	sd	s2,32(sp)
 52c:	ec4e                	sd	s3,24(sp)
 52e:	fc040793          	addi	a5,s0,-64
 532:	00e78933          	add	s2,a5,a4
 536:	fff78993          	addi	s3,a5,-1
 53a:	99ba                	add	s3,s3,a4
 53c:	377d                	addiw	a4,a4,-1
 53e:	1702                	slli	a4,a4,0x20
 540:	9301                	srli	a4,a4,0x20
 542:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 546:	fff94583          	lbu	a1,-1(s2)
 54a:	8526                	mv	a0,s1
 54c:	00000097          	auipc	ra,0x0
 550:	f56080e7          	jalr	-170(ra) # 4a2 <putc>
  while(--i >= 0)
 554:	197d                	addi	s2,s2,-1
 556:	ff3918e3          	bne	s2,s3,546 <printint+0x82>
 55a:	7902                	ld	s2,32(sp)
 55c:	69e2                	ld	s3,24(sp)
}
 55e:	70e2                	ld	ra,56(sp)
 560:	7442                	ld	s0,48(sp)
 562:	74a2                	ld	s1,40(sp)
 564:	6121                	addi	sp,sp,64
 566:	8082                	ret
    x = -xx;
 568:	40b005bb          	negw	a1,a1
    neg = 1;
 56c:	4885                	li	a7,1
    x = -xx;
 56e:	b7b5                	j	4da <printint+0x16>

0000000000000570 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 570:	715d                	addi	sp,sp,-80
 572:	e486                	sd	ra,72(sp)
 574:	e0a2                	sd	s0,64(sp)
 576:	f84a                	sd	s2,48(sp)
 578:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 57a:	0005c903          	lbu	s2,0(a1)
 57e:	1a090a63          	beqz	s2,732 <vprintf+0x1c2>
 582:	fc26                	sd	s1,56(sp)
 584:	f44e                	sd	s3,40(sp)
 586:	f052                	sd	s4,32(sp)
 588:	ec56                	sd	s5,24(sp)
 58a:	e85a                	sd	s6,16(sp)
 58c:	e45e                	sd	s7,8(sp)
 58e:	8aaa                	mv	s5,a0
 590:	8bb2                	mv	s7,a2
 592:	00158493          	addi	s1,a1,1
  state = 0;
 596:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 598:	02500a13          	li	s4,37
 59c:	4b55                	li	s6,21
 59e:	a839                	j	5bc <vprintf+0x4c>
        putc(fd, c);
 5a0:	85ca                	mv	a1,s2
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	efe080e7          	jalr	-258(ra) # 4a2 <putc>
 5ac:	a019                	j	5b2 <vprintf+0x42>
    } else if(state == '%'){
 5ae:	01498d63          	beq	s3,s4,5c8 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5b2:	0485                	addi	s1,s1,1
 5b4:	fff4c903          	lbu	s2,-1(s1)
 5b8:	16090763          	beqz	s2,726 <vprintf+0x1b6>
    if(state == 0){
 5bc:	fe0999e3          	bnez	s3,5ae <vprintf+0x3e>
      if(c == '%'){
 5c0:	ff4910e3          	bne	s2,s4,5a0 <vprintf+0x30>
        state = '%';
 5c4:	89d2                	mv	s3,s4
 5c6:	b7f5                	j	5b2 <vprintf+0x42>
      if(c == 'd'){
 5c8:	13490463          	beq	s2,s4,6f0 <vprintf+0x180>
 5cc:	f9d9079b          	addiw	a5,s2,-99
 5d0:	0ff7f793          	zext.b	a5,a5
 5d4:	12fb6763          	bltu	s6,a5,702 <vprintf+0x192>
 5d8:	f9d9079b          	addiw	a5,s2,-99
 5dc:	0ff7f713          	zext.b	a4,a5
 5e0:	12eb6163          	bltu	s6,a4,702 <vprintf+0x192>
 5e4:	00271793          	slli	a5,a4,0x2
 5e8:	00000717          	auipc	a4,0x0
 5ec:	50070713          	addi	a4,a4,1280 # ae8 <malloc+0x190>
 5f0:	97ba                	add	a5,a5,a4
 5f2:	439c                	lw	a5,0(a5)
 5f4:	97ba                	add	a5,a5,a4
 5f6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000ba583          	lw	a1,0(s7)
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	ebe080e7          	jalr	-322(ra) # 4c4 <printint>
 60e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 610:	4981                	li	s3,0
 612:	b745                	j	5b2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	008b8913          	addi	s2,s7,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000ba583          	lw	a1,0(s7)
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	ea2080e7          	jalr	-350(ra) # 4c4 <printint>
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b751                	j	5b2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 630:	008b8913          	addi	s2,s7,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000ba583          	lw	a1,0(s7)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e86080e7          	jalr	-378(ra) # 4c4 <printint>
 646:	8bca                	mv	s7,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	b7a5                	j	5b2 <vprintf+0x42>
 64c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 64e:	008b8c13          	addi	s8,s7,8
 652:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 656:	03000593          	li	a1,48
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	e46080e7          	jalr	-442(ra) # 4a2 <putc>
  putc(fd, 'x');
 664:	07800593          	li	a1,120
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e38080e7          	jalr	-456(ra) # 4a2 <putc>
 672:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 674:	00000b97          	auipc	s7,0x0
 678:	4ccb8b93          	addi	s7,s7,1228 # b40 <digits>
 67c:	03c9d793          	srli	a5,s3,0x3c
 680:	97de                	add	a5,a5,s7
 682:	0007c583          	lbu	a1,0(a5)
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	e1a080e7          	jalr	-486(ra) # 4a2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 690:	0992                	slli	s3,s3,0x4
 692:	397d                	addiw	s2,s2,-1
 694:	fe0914e3          	bnez	s2,67c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 698:	8be2                	mv	s7,s8
      state = 0;
 69a:	4981                	li	s3,0
 69c:	6c02                	ld	s8,0(sp)
 69e:	bf11                	j	5b2 <vprintf+0x42>
        s = va_arg(ap, char*);
 6a0:	008b8993          	addi	s3,s7,8
 6a4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6a8:	02090163          	beqz	s2,6ca <vprintf+0x15a>
        while(*s != 0){
 6ac:	00094583          	lbu	a1,0(s2)
 6b0:	c9a5                	beqz	a1,720 <vprintf+0x1b0>
          putc(fd, *s);
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	dee080e7          	jalr	-530(ra) # 4a2 <putc>
          s++;
 6bc:	0905                	addi	s2,s2,1
        while(*s != 0){
 6be:	00094583          	lbu	a1,0(s2)
 6c2:	f9e5                	bnez	a1,6b2 <vprintf+0x142>
        s = va_arg(ap, char*);
 6c4:	8bce                	mv	s7,s3
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b5ed                	j	5b2 <vprintf+0x42>
          s = "(null)";
 6ca:	00000917          	auipc	s2,0x0
 6ce:	41690913          	addi	s2,s2,1046 # ae0 <malloc+0x188>
        while(*s != 0){
 6d2:	02800593          	li	a1,40
 6d6:	bff1                	j	6b2 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	000bc583          	lbu	a1,0(s7)
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	dc0080e7          	jalr	-576(ra) # 4a2 <putc>
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b5d1                	j	5b2 <vprintf+0x42>
        putc(fd, c);
 6f0:	02500593          	li	a1,37
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	dac080e7          	jalr	-596(ra) # 4a2 <putc>
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bd4d                	j	5b2 <vprintf+0x42>
        putc(fd, '%');
 702:	02500593          	li	a1,37
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	d9a080e7          	jalr	-614(ra) # 4a2 <putc>
        putc(fd, c);
 710:	85ca                	mv	a1,s2
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	d8e080e7          	jalr	-626(ra) # 4a2 <putc>
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bd51                	j	5b2 <vprintf+0x42>
        s = va_arg(ap, char*);
 720:	8bce                	mv	s7,s3
      state = 0;
 722:	4981                	li	s3,0
 724:	b579                	j	5b2 <vprintf+0x42>
 726:	74e2                	ld	s1,56(sp)
 728:	79a2                	ld	s3,40(sp)
 72a:	7a02                	ld	s4,32(sp)
 72c:	6ae2                	ld	s5,24(sp)
 72e:	6b42                	ld	s6,16(sp)
 730:	6ba2                	ld	s7,8(sp)
    }
  }
}
 732:	60a6                	ld	ra,72(sp)
 734:	6406                	ld	s0,64(sp)
 736:	7942                	ld	s2,48(sp)
 738:	6161                	addi	sp,sp,80
 73a:	8082                	ret

000000000000073c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73c:	715d                	addi	sp,sp,-80
 73e:	ec06                	sd	ra,24(sp)
 740:	e822                	sd	s0,16(sp)
 742:	1000                	addi	s0,sp,32
 744:	e010                	sd	a2,0(s0)
 746:	e414                	sd	a3,8(s0)
 748:	e818                	sd	a4,16(s0)
 74a:	ec1c                	sd	a5,24(s0)
 74c:	03043023          	sd	a6,32(s0)
 750:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 754:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 758:	8622                	mv	a2,s0
 75a:	00000097          	auipc	ra,0x0
 75e:	e16080e7          	jalr	-490(ra) # 570 <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6161                	addi	sp,sp,80
 768:	8082                	ret

000000000000076a <printf>:

void
printf(const char *fmt, ...)
{
 76a:	7159                	addi	sp,sp,-112
 76c:	f406                	sd	ra,40(sp)
 76e:	f022                	sd	s0,32(sp)
 770:	ec26                	sd	s1,24(sp)
 772:	1800                	addi	s0,sp,48
 774:	84aa                	mv	s1,a0
 776:	e40c                	sd	a1,8(s0)
 778:	e810                	sd	a2,16(s0)
 77a:	ec14                	sd	a3,24(s0)
 77c:	f018                	sd	a4,32(s0)
 77e:	f41c                	sd	a5,40(s0)
 780:	03043823          	sd	a6,48(s0)
 784:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 788:	00000097          	auipc	ra,0x0
 78c:	d0a080e7          	jalr	-758(ra) # 492 <lock>
  va_start(ap, fmt);
 790:	00840613          	addi	a2,s0,8
 794:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 798:	85a6                	mv	a1,s1
 79a:	4505                	li	a0,1
 79c:	00000097          	auipc	ra,0x0
 7a0:	dd4080e7          	jalr	-556(ra) # 570 <vprintf>
  unlock();
 7a4:	00000097          	auipc	ra,0x0
 7a8:	cf6080e7          	jalr	-778(ra) # 49a <unlock>
}
 7ac:	70a2                	ld	ra,40(sp)
 7ae:	7402                	ld	s0,32(sp)
 7b0:	64e2                	ld	s1,24(sp)
 7b2:	6165                	addi	sp,sp,112
 7b4:	8082                	ret

00000000000007b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b6:	7179                	addi	sp,sp,-48
 7b8:	f422                	sd	s0,40(sp)
 7ba:	1800                	addi	s0,sp,48
 7bc:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c0:	fd843783          	ld	a5,-40(s0)
 7c4:	17c1                	addi	a5,a5,-16
 7c6:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	00001797          	auipc	a5,0x1
 7ce:	bf678793          	addi	a5,a5,-1034 # 13c0 <freep>
 7d2:	639c                	ld	a5,0(a5)
 7d4:	fef43423          	sd	a5,-24(s0)
 7d8:	a815                	j	80c <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7da:	fe843783          	ld	a5,-24(s0)
 7de:	639c                	ld	a5,0(a5)
 7e0:	fe843703          	ld	a4,-24(s0)
 7e4:	00f76f63          	bltu	a4,a5,802 <free+0x4c>
 7e8:	fe043703          	ld	a4,-32(s0)
 7ec:	fe843783          	ld	a5,-24(s0)
 7f0:	02e7eb63          	bltu	a5,a4,826 <free+0x70>
 7f4:	fe843783          	ld	a5,-24(s0)
 7f8:	639c                	ld	a5,0(a5)
 7fa:	fe043703          	ld	a4,-32(s0)
 7fe:	02f76463          	bltu	a4,a5,826 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 802:	fe843783          	ld	a5,-24(s0)
 806:	639c                	ld	a5,0(a5)
 808:	fef43423          	sd	a5,-24(s0)
 80c:	fe043703          	ld	a4,-32(s0)
 810:	fe843783          	ld	a5,-24(s0)
 814:	fce7f3e3          	bgeu	a5,a4,7da <free+0x24>
 818:	fe843783          	ld	a5,-24(s0)
 81c:	639c                	ld	a5,0(a5)
 81e:	fe043703          	ld	a4,-32(s0)
 822:	faf77ce3          	bgeu	a4,a5,7da <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 826:	fe043783          	ld	a5,-32(s0)
 82a:	479c                	lw	a5,8(a5)
 82c:	1782                	slli	a5,a5,0x20
 82e:	9381                	srli	a5,a5,0x20
 830:	0792                	slli	a5,a5,0x4
 832:	fe043703          	ld	a4,-32(s0)
 836:	973e                	add	a4,a4,a5
 838:	fe843783          	ld	a5,-24(s0)
 83c:	639c                	ld	a5,0(a5)
 83e:	02f71763          	bne	a4,a5,86c <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 842:	fe043783          	ld	a5,-32(s0)
 846:	4798                	lw	a4,8(a5)
 848:	fe843783          	ld	a5,-24(s0)
 84c:	639c                	ld	a5,0(a5)
 84e:	479c                	lw	a5,8(a5)
 850:	9fb9                	addw	a5,a5,a4
 852:	0007871b          	sext.w	a4,a5
 856:	fe043783          	ld	a5,-32(s0)
 85a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 85c:	fe843783          	ld	a5,-24(s0)
 860:	639c                	ld	a5,0(a5)
 862:	6398                	ld	a4,0(a5)
 864:	fe043783          	ld	a5,-32(s0)
 868:	e398                	sd	a4,0(a5)
 86a:	a039                	j	878 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 86c:	fe843783          	ld	a5,-24(s0)
 870:	6398                	ld	a4,0(a5)
 872:	fe043783          	ld	a5,-32(s0)
 876:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 878:	fe843783          	ld	a5,-24(s0)
 87c:	479c                	lw	a5,8(a5)
 87e:	1782                	slli	a5,a5,0x20
 880:	9381                	srli	a5,a5,0x20
 882:	0792                	slli	a5,a5,0x4
 884:	fe843703          	ld	a4,-24(s0)
 888:	97ba                	add	a5,a5,a4
 88a:	fe043703          	ld	a4,-32(s0)
 88e:	02f71563          	bne	a4,a5,8b8 <free+0x102>
    p->s.size += bp->s.size;
 892:	fe843783          	ld	a5,-24(s0)
 896:	4798                	lw	a4,8(a5)
 898:	fe043783          	ld	a5,-32(s0)
 89c:	479c                	lw	a5,8(a5)
 89e:	9fb9                	addw	a5,a5,a4
 8a0:	0007871b          	sext.w	a4,a5
 8a4:	fe843783          	ld	a5,-24(s0)
 8a8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8aa:	fe043783          	ld	a5,-32(s0)
 8ae:	6398                	ld	a4,0(a5)
 8b0:	fe843783          	ld	a5,-24(s0)
 8b4:	e398                	sd	a4,0(a5)
 8b6:	a031                	j	8c2 <free+0x10c>
  } else
    p->s.ptr = bp;
 8b8:	fe843783          	ld	a5,-24(s0)
 8bc:	fe043703          	ld	a4,-32(s0)
 8c0:	e398                	sd	a4,0(a5)
  freep = p;
 8c2:	00001797          	auipc	a5,0x1
 8c6:	afe78793          	addi	a5,a5,-1282 # 13c0 <freep>
 8ca:	fe843703          	ld	a4,-24(s0)
 8ce:	e398                	sd	a4,0(a5)
}
 8d0:	0001                	nop
 8d2:	7422                	ld	s0,40(sp)
 8d4:	6145                	addi	sp,sp,48
 8d6:	8082                	ret

00000000000008d8 <morecore>:

static Header*
morecore(uint nu)
{
 8d8:	7179                	addi	sp,sp,-48
 8da:	f406                	sd	ra,40(sp)
 8dc:	f022                	sd	s0,32(sp)
 8de:	1800                	addi	s0,sp,48
 8e0:	87aa                	mv	a5,a0
 8e2:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 8e6:	fdc42783          	lw	a5,-36(s0)
 8ea:	0007871b          	sext.w	a4,a5
 8ee:	6785                	lui	a5,0x1
 8f0:	00f77563          	bgeu	a4,a5,8fa <morecore+0x22>
    nu = 4096;
 8f4:	6785                	lui	a5,0x1
 8f6:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 8fa:	fdc42783          	lw	a5,-36(s0)
 8fe:	0047979b          	slliw	a5,a5,0x4
 902:	2781                	sext.w	a5,a5
 904:	2781                	sext.w	a5,a5
 906:	853e                	mv	a0,a5
 908:	00000097          	auipc	ra,0x0
 90c:	b6a080e7          	jalr	-1174(ra) # 472 <sbrk>
 910:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 914:	fe843703          	ld	a4,-24(s0)
 918:	57fd                	li	a5,-1
 91a:	00f71463          	bne	a4,a5,922 <morecore+0x4a>
    return 0;
 91e:	4781                	li	a5,0
 920:	a03d                	j	94e <morecore+0x76>
  hp = (Header*)p;
 922:	fe843783          	ld	a5,-24(s0)
 926:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 92a:	fe043783          	ld	a5,-32(s0)
 92e:	fdc42703          	lw	a4,-36(s0)
 932:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 934:	fe043783          	ld	a5,-32(s0)
 938:	07c1                	addi	a5,a5,16 # 1010 <digits+0x4d0>
 93a:	853e                	mv	a0,a5
 93c:	00000097          	auipc	ra,0x0
 940:	e7a080e7          	jalr	-390(ra) # 7b6 <free>
  return freep;
 944:	00001797          	auipc	a5,0x1
 948:	a7c78793          	addi	a5,a5,-1412 # 13c0 <freep>
 94c:	639c                	ld	a5,0(a5)
}
 94e:	853e                	mv	a0,a5
 950:	70a2                	ld	ra,40(sp)
 952:	7402                	ld	s0,32(sp)
 954:	6145                	addi	sp,sp,48
 956:	8082                	ret

0000000000000958 <malloc>:

void*
malloc(uint nbytes)
{
 958:	7139                	addi	sp,sp,-64
 95a:	fc06                	sd	ra,56(sp)
 95c:	f822                	sd	s0,48(sp)
 95e:	0080                	addi	s0,sp,64
 960:	87aa                	mv	a5,a0
 962:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 966:	fcc46783          	lwu	a5,-52(s0)
 96a:	07bd                	addi	a5,a5,15
 96c:	8391                	srli	a5,a5,0x4
 96e:	2781                	sext.w	a5,a5
 970:	2785                	addiw	a5,a5,1
 972:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 976:	00001797          	auipc	a5,0x1
 97a:	a4a78793          	addi	a5,a5,-1462 # 13c0 <freep>
 97e:	639c                	ld	a5,0(a5)
 980:	fef43023          	sd	a5,-32(s0)
 984:	fe043783          	ld	a5,-32(s0)
 988:	ef95                	bnez	a5,9c4 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 98a:	00001797          	auipc	a5,0x1
 98e:	a2678793          	addi	a5,a5,-1498 # 13b0 <base>
 992:	fef43023          	sd	a5,-32(s0)
 996:	00001797          	auipc	a5,0x1
 99a:	a2a78793          	addi	a5,a5,-1494 # 13c0 <freep>
 99e:	fe043703          	ld	a4,-32(s0)
 9a2:	e398                	sd	a4,0(a5)
 9a4:	00001797          	auipc	a5,0x1
 9a8:	a1c78793          	addi	a5,a5,-1508 # 13c0 <freep>
 9ac:	6398                	ld	a4,0(a5)
 9ae:	00001797          	auipc	a5,0x1
 9b2:	a0278793          	addi	a5,a5,-1534 # 13b0 <base>
 9b6:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 9b8:	00001797          	auipc	a5,0x1
 9bc:	9f878793          	addi	a5,a5,-1544 # 13b0 <base>
 9c0:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c4:	fe043783          	ld	a5,-32(s0)
 9c8:	639c                	ld	a5,0(a5)
 9ca:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 9ce:	fe843783          	ld	a5,-24(s0)
 9d2:	4798                	lw	a4,8(a5)
 9d4:	fdc42783          	lw	a5,-36(s0)
 9d8:	2781                	sext.w	a5,a5
 9da:	06f76763          	bltu	a4,a5,a48 <malloc+0xf0>
      if(p->s.size == nunits)
 9de:	fe843783          	ld	a5,-24(s0)
 9e2:	4798                	lw	a4,8(a5)
 9e4:	fdc42783          	lw	a5,-36(s0)
 9e8:	2781                	sext.w	a5,a5
 9ea:	00e79963          	bne	a5,a4,9fc <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 9ee:	fe843783          	ld	a5,-24(s0)
 9f2:	6398                	ld	a4,0(a5)
 9f4:	fe043783          	ld	a5,-32(s0)
 9f8:	e398                	sd	a4,0(a5)
 9fa:	a825                	j	a32 <malloc+0xda>
      else {
        p->s.size -= nunits;
 9fc:	fe843783          	ld	a5,-24(s0)
 a00:	479c                	lw	a5,8(a5)
 a02:	fdc42703          	lw	a4,-36(s0)
 a06:	9f99                	subw	a5,a5,a4
 a08:	0007871b          	sext.w	a4,a5
 a0c:	fe843783          	ld	a5,-24(s0)
 a10:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a12:	fe843783          	ld	a5,-24(s0)
 a16:	479c                	lw	a5,8(a5)
 a18:	1782                	slli	a5,a5,0x20
 a1a:	9381                	srli	a5,a5,0x20
 a1c:	0792                	slli	a5,a5,0x4
 a1e:	fe843703          	ld	a4,-24(s0)
 a22:	97ba                	add	a5,a5,a4
 a24:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 a28:	fe843783          	ld	a5,-24(s0)
 a2c:	fdc42703          	lw	a4,-36(s0)
 a30:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 a32:	00001797          	auipc	a5,0x1
 a36:	98e78793          	addi	a5,a5,-1650 # 13c0 <freep>
 a3a:	fe043703          	ld	a4,-32(s0)
 a3e:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 a40:	fe843783          	ld	a5,-24(s0)
 a44:	07c1                	addi	a5,a5,16
 a46:	a091                	j	a8a <malloc+0x132>
    }
    if(p == freep)
 a48:	00001797          	auipc	a5,0x1
 a4c:	97878793          	addi	a5,a5,-1672 # 13c0 <freep>
 a50:	639c                	ld	a5,0(a5)
 a52:	fe843703          	ld	a4,-24(s0)
 a56:	02f71063          	bne	a4,a5,a76 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 a5a:	fdc42783          	lw	a5,-36(s0)
 a5e:	853e                	mv	a0,a5
 a60:	00000097          	auipc	ra,0x0
 a64:	e78080e7          	jalr	-392(ra) # 8d8 <morecore>
 a68:	fea43423          	sd	a0,-24(s0)
 a6c:	fe843783          	ld	a5,-24(s0)
 a70:	e399                	bnez	a5,a76 <malloc+0x11e>
        return 0;
 a72:	4781                	li	a5,0
 a74:	a819                	j	a8a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a76:	fe843783          	ld	a5,-24(s0)
 a7a:	fef43023          	sd	a5,-32(s0)
 a7e:	fe843783          	ld	a5,-24(s0)
 a82:	639c                	ld	a5,0(a5)
 a84:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 a88:	b799                	j	9ce <malloc+0x76>
  }
}
 a8a:	853e                	mv	a0,a5
 a8c:	70e2                	ld	ra,56(sp)
 a8e:	7442                	ld	s0,48(sp)
 a90:	6121                	addi	sp,sp,64
 a92:	8082                	ret
