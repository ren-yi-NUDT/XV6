
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	da010113          	addi	sp,sp,-608
   4:	24113c23          	sd	ra,600(sp)
   8:	24813823          	sd	s0,592(sp)
   c:	24913423          	sd	s1,584(sp)
  10:	25213023          	sd	s2,576(sp)
  14:	23313c23          	sd	s3,568(sp)
  18:	23413823          	sd	s4,560(sp)
  1c:	23513423          	sd	s5,552(sp)
  20:	23613023          	sd	s6,544(sp)
  24:	21713c23          	sd	s7,536(sp)
  28:	1480                	addi	s0,sp,608
    char buf[512];      
    int buf_pos = 0;    
    char ch;
    if (argc < 2) {
  2a:	4785                	li	a5,1
  2c:	02a7d763          	bge	a5,a0,5a <main+0x5a>
  30:	8b2e                	mv	s6,a1
    while (read(0, &ch, 1) > 0) {
        if (ch == '\n') {

            buf[buf_pos] = '\0';  
    
            char *new_argv[argc + 2];  
  32:	00250a9b          	addiw	s5,a0,2
  36:	0a8e                	slli	s5,s5,0x3
  38:	ffe5091b          	addiw	s2,a0,-2
  3c:	02091793          	slli	a5,s2,0x20
  40:	01d7d913          	srli	s2,a5,0x1d
  44:	01058793          	addi	a5,a1,16
  48:	993e                	add	s2,s2,a5
    int buf_pos = 0;    
  4a:	4481                	li	s1,0
        if (ch == '\n') {
  4c:	49a9                	li	s3,10
            char *new_argv[argc + 2];  
  4e:	0abd                	addi	s5,s5,15
  50:	ff0afa93          	andi	s5,s5,-16
  54:	00351a13          	slli	s4,a0,0x3
  58:	a0b5                	j	c4 <main+0xc4>
        fprintf(2, "Usage: xargs command [args...]\n");
  5a:	00001597          	auipc	a1,0x1
  5e:	9f658593          	addi	a1,a1,-1546 # a50 <malloc+0x13c>
  62:	4509                	li	a0,2
  64:	00000097          	auipc	ra,0x0
  68:	694080e7          	jalr	1684(ra) # 6f8 <fprintf>
        exit(1);
  6c:	4505                	li	a0,1
  6e:	00000097          	auipc	ra,0x0
  72:	338080e7          	jalr	824(ra) # 3a6 <exit>
        if (ch == '\n') {
  76:	8b8a                	mv	s7,sp
            buf[buf_pos] = '\0';  
  78:	fb048793          	addi	a5,s1,-80
  7c:	008784b3          	add	s1,a5,s0
  80:	e0048023          	sb	zero,-512(s1)
            char *new_argv[argc + 2];  
  84:	41510133          	sub	sp,sp,s5
  88:	848a                	mv	s1,sp
            for (int i = 1; i < argc; i++) {
  8a:	008b0793          	addi	a5,s6,8
  8e:	8726                	mv	a4,s1
                new_argv[i - 1] = argv[i];
  90:	6394                	ld	a3,0(a5)
  92:	e314                	sd	a3,0(a4)
            for (int i = 1; i < argc; i++) {
  94:	07a1                	addi	a5,a5,8
  96:	0721                	addi	a4,a4,8
  98:	ff279ce3          	bne	a5,s2,90 <main+0x90>
            }
            new_argv[argc - 1] = buf;    
  9c:	014487b3          	add	a5,s1,s4
  a0:	db040713          	addi	a4,s0,-592
  a4:	fee7bc23          	sd	a4,-8(a5)
            new_argv[argc] = 0;         
  a8:	0007b023          	sd	zero,0(a5)

            if (fork() == 0) {
  ac:	00000097          	auipc	ra,0x0
  b0:	2f2080e7          	jalr	754(ra) # 39e <fork>
  b4:	cd0d                	beqz	a0,ee <main+0xee>
                exec(new_argv[0], new_argv);
                fprintf(2, "exec failed\n");
                exit(1);
            }
            wait(0);
  b6:	4501                	li	a0,0
  b8:	00000097          	auipc	ra,0x0
  bc:	2f6080e7          	jalr	758(ra) # 3ae <wait>
            
            buf_pos = 0;  
  c0:	815e                	mv	sp,s7
  c2:	4481                	li	s1,0
    while (read(0, &ch, 1) > 0) {
  c4:	4605                	li	a2,1
  c6:	daf40593          	addi	a1,s0,-593
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	2f2080e7          	jalr	754(ra) # 3be <read>
  d4:	04a05163          	blez	a0,116 <main+0x116>
        if (ch == '\n') {
  d8:	daf44783          	lbu	a5,-593(s0)
  dc:	f9378de3          	beq	a5,s3,76 <main+0x76>
        } else {
            buf[buf_pos++] = ch;
  e0:	fb048713          	addi	a4,s1,-80
  e4:	9722                	add	a4,a4,s0
  e6:	e0f70023          	sb	a5,-512(a4)
  ea:	2485                	addiw	s1,s1,1
  ec:	bfe1                	j	c4 <main+0xc4>
                exec(new_argv[0], new_argv);
  ee:	85a6                	mv	a1,s1
  f0:	6088                	ld	a0,0(s1)
  f2:	00000097          	auipc	ra,0x0
  f6:	2ec080e7          	jalr	748(ra) # 3de <exec>
                fprintf(2, "exec failed\n");
  fa:	00001597          	auipc	a1,0x1
  fe:	97658593          	addi	a1,a1,-1674 # a70 <malloc+0x15c>
 102:	4509                	li	a0,2
 104:	00000097          	auipc	ra,0x0
 108:	5f4080e7          	jalr	1524(ra) # 6f8 <fprintf>
                exit(1);
 10c:	4505                	li	a0,1
 10e:	00000097          	auipc	ra,0x0
 112:	298080e7          	jalr	664(ra) # 3a6 <exit>
        }
    }

    exit(0);
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	28e080e7          	jalr	654(ra) # 3a6 <exit>

0000000000000120 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 120:	1141                	addi	sp,sp,-16
 122:	e406                	sd	ra,8(sp)
 124:	e022                	sd	s0,0(sp)
 126:	0800                	addi	s0,sp,16
  extern int main();
  main();
 128:	00000097          	auipc	ra,0x0
 12c:	ed8080e7          	jalr	-296(ra) # 0 <main>
  exit(0);
 130:	4501                	li	a0,0
 132:	00000097          	auipc	ra,0x0
 136:	274080e7          	jalr	628(ra) # 3a6 <exit>

000000000000013a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 140:	87aa                	mv	a5,a0
 142:	0585                	addi	a1,a1,1
 144:	0785                	addi	a5,a5,1
 146:	fff5c703          	lbu	a4,-1(a1)
 14a:	fee78fa3          	sb	a4,-1(a5)
 14e:	fb75                	bnez	a4,142 <strcpy+0x8>
    ;
  return os;
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 156:	1141                	addi	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15c:	00054783          	lbu	a5,0(a0)
 160:	cb91                	beqz	a5,174 <strcmp+0x1e>
 162:	0005c703          	lbu	a4,0(a1)
 166:	00f71763          	bne	a4,a5,174 <strcmp+0x1e>
    p++, q++;
 16a:	0505                	addi	a0,a0,1
 16c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 16e:	00054783          	lbu	a5,0(a0)
 172:	fbe5                	bnez	a5,162 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 174:	0005c503          	lbu	a0,0(a1)
}
 178:	40a7853b          	subw	a0,a5,a0
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret

0000000000000182 <strlen>:

uint
strlen(const char *s)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 188:	00054783          	lbu	a5,0(a0)
 18c:	cf91                	beqz	a5,1a8 <strlen+0x26>
 18e:	0505                	addi	a0,a0,1
 190:	87aa                	mv	a5,a0
 192:	86be                	mv	a3,a5
 194:	0785                	addi	a5,a5,1
 196:	fff7c703          	lbu	a4,-1(a5)
 19a:	ff65                	bnez	a4,192 <strlen+0x10>
 19c:	40a6853b          	subw	a0,a3,a0
 1a0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret
  for(n = 0; s[n]; n++)
 1a8:	4501                	li	a0,0
 1aa:	bfe5                	j	1a2 <strlen+0x20>

00000000000001ac <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e422                	sd	s0,8(sp)
 1b0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b2:	ca19                	beqz	a2,1c8 <memset+0x1c>
 1b4:	87aa                	mv	a5,a0
 1b6:	1602                	slli	a2,a2,0x20
 1b8:	9201                	srli	a2,a2,0x20
 1ba:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1be:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c2:	0785                	addi	a5,a5,1
 1c4:	fee79de3          	bne	a5,a4,1be <memset+0x12>
  }
  return dst;
}
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret

00000000000001ce <strchr>:

char*
strchr(const char *s, char c)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	cb99                	beqz	a5,1ee <strchr+0x20>
    if(*s == c)
 1da:	00f58763          	beq	a1,a5,1e8 <strchr+0x1a>
  for(; *s; s++)
 1de:	0505                	addi	a0,a0,1
 1e0:	00054783          	lbu	a5,0(a0)
 1e4:	fbfd                	bnez	a5,1da <strchr+0xc>
      return (char*)s;
  return 0;
 1e6:	4501                	li	a0,0
}
 1e8:	6422                	ld	s0,8(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret
  return 0;
 1ee:	4501                	li	a0,0
 1f0:	bfe5                	j	1e8 <strchr+0x1a>

00000000000001f2 <gets>:

char*
gets(char *buf, int max)
{
 1f2:	711d                	addi	sp,sp,-96
 1f4:	ec86                	sd	ra,88(sp)
 1f6:	e8a2                	sd	s0,80(sp)
 1f8:	e4a6                	sd	s1,72(sp)
 1fa:	e0ca                	sd	s2,64(sp)
 1fc:	fc4e                	sd	s3,56(sp)
 1fe:	f852                	sd	s4,48(sp)
 200:	f456                	sd	s5,40(sp)
 202:	f05a                	sd	s6,32(sp)
 204:	ec5e                	sd	s7,24(sp)
 206:	1080                	addi	s0,sp,96
 208:	8baa                	mv	s7,a0
 20a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20c:	892a                	mv	s2,a0
 20e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 210:	4aa9                	li	s5,10
 212:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 214:	89a6                	mv	s3,s1
 216:	2485                	addiw	s1,s1,1
 218:	0344d863          	bge	s1,s4,248 <gets+0x56>
    cc = read(0, &c, 1);
 21c:	4605                	li	a2,1
 21e:	faf40593          	addi	a1,s0,-81
 222:	4501                	li	a0,0
 224:	00000097          	auipc	ra,0x0
 228:	19a080e7          	jalr	410(ra) # 3be <read>
    if(cc < 1)
 22c:	00a05e63          	blez	a0,248 <gets+0x56>
    buf[i++] = c;
 230:	faf44783          	lbu	a5,-81(s0)
 234:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 238:	01578763          	beq	a5,s5,246 <gets+0x54>
 23c:	0905                	addi	s2,s2,1
 23e:	fd679be3          	bne	a5,s6,214 <gets+0x22>
    buf[i++] = c;
 242:	89a6                	mv	s3,s1
 244:	a011                	j	248 <gets+0x56>
 246:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 248:	99de                	add	s3,s3,s7
 24a:	00098023          	sb	zero,0(s3)
  return buf;
}
 24e:	855e                	mv	a0,s7
 250:	60e6                	ld	ra,88(sp)
 252:	6446                	ld	s0,80(sp)
 254:	64a6                	ld	s1,72(sp)
 256:	6906                	ld	s2,64(sp)
 258:	79e2                	ld	s3,56(sp)
 25a:	7a42                	ld	s4,48(sp)
 25c:	7aa2                	ld	s5,40(sp)
 25e:	7b02                	ld	s6,32(sp)
 260:	6be2                	ld	s7,24(sp)
 262:	6125                	addi	sp,sp,96
 264:	8082                	ret

0000000000000266 <stat>:

int
stat(const char *n, struct stat *st)
{
 266:	1101                	addi	sp,sp,-32
 268:	ec06                	sd	ra,24(sp)
 26a:	e822                	sd	s0,16(sp)
 26c:	e04a                	sd	s2,0(sp)
 26e:	1000                	addi	s0,sp,32
 270:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 272:	4581                	li	a1,0
 274:	00000097          	auipc	ra,0x0
 278:	172080e7          	jalr	370(ra) # 3e6 <open>
  if(fd < 0)
 27c:	02054663          	bltz	a0,2a8 <stat+0x42>
 280:	e426                	sd	s1,8(sp)
 282:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 284:	85ca                	mv	a1,s2
 286:	00000097          	auipc	ra,0x0
 28a:	178080e7          	jalr	376(ra) # 3fe <fstat>
 28e:	892a                	mv	s2,a0
  close(fd);
 290:	8526                	mv	a0,s1
 292:	00000097          	auipc	ra,0x0
 296:	13c080e7          	jalr	316(ra) # 3ce <close>
  return r;
 29a:	64a2                	ld	s1,8(sp)
}
 29c:	854a                	mv	a0,s2
 29e:	60e2                	ld	ra,24(sp)
 2a0:	6442                	ld	s0,16(sp)
 2a2:	6902                	ld	s2,0(sp)
 2a4:	6105                	addi	sp,sp,32
 2a6:	8082                	ret
    return -1;
 2a8:	597d                	li	s2,-1
 2aa:	bfcd                	j	29c <stat+0x36>

00000000000002ac <atoi>:

int
atoi(const char *s)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e422                	sd	s0,8(sp)
 2b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b2:	00054683          	lbu	a3,0(a0)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	4625                	li	a2,9
 2c0:	02f66863          	bltu	a2,a5,2f0 <atoi+0x44>
 2c4:	872a                	mv	a4,a0
  n = 0;
 2c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c8:	0705                	addi	a4,a4,1
 2ca:	0025179b          	slliw	a5,a0,0x2
 2ce:	9fa9                	addw	a5,a5,a0
 2d0:	0017979b          	slliw	a5,a5,0x1
 2d4:	9fb5                	addw	a5,a5,a3
 2d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2da:	00074683          	lbu	a3,0(a4)
 2de:	fd06879b          	addiw	a5,a3,-48
 2e2:	0ff7f793          	zext.b	a5,a5
 2e6:	fef671e3          	bgeu	a2,a5,2c8 <atoi+0x1c>
  return n;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  n = 0;
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <atoi+0x3e>

00000000000002f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fa:	02b57463          	bgeu	a0,a1,322 <memmove+0x2e>
    while(n-- > 0)
 2fe:	00c05f63          	blez	a2,31c <memmove+0x28>
 302:	1602                	slli	a2,a2,0x20
 304:	9201                	srli	a2,a2,0x20
 306:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 30a:	872a                	mv	a4,a0
      *dst++ = *src++;
 30c:	0585                	addi	a1,a1,1
 30e:	0705                	addi	a4,a4,1
 310:	fff5c683          	lbu	a3,-1(a1)
 314:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 318:	fef71ae3          	bne	a4,a5,30c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
    dst += n;
 322:	00c50733          	add	a4,a0,a2
    src += n;
 326:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 328:	fec05ae3          	blez	a2,31c <memmove+0x28>
 32c:	fff6079b          	addiw	a5,a2,-1
 330:	1782                	slli	a5,a5,0x20
 332:	9381                	srli	a5,a5,0x20
 334:	fff7c793          	not	a5,a5
 338:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33a:	15fd                	addi	a1,a1,-1
 33c:	177d                	addi	a4,a4,-1
 33e:	0005c683          	lbu	a3,0(a1)
 342:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 346:	fee79ae3          	bne	a5,a4,33a <memmove+0x46>
 34a:	bfc9                	j	31c <memmove+0x28>

000000000000034c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 352:	ca05                	beqz	a2,382 <memcmp+0x36>
 354:	fff6069b          	addiw	a3,a2,-1
 358:	1682                	slli	a3,a3,0x20
 35a:	9281                	srli	a3,a3,0x20
 35c:	0685                	addi	a3,a3,1
 35e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 360:	00054783          	lbu	a5,0(a0)
 364:	0005c703          	lbu	a4,0(a1)
 368:	00e79863          	bne	a5,a4,378 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36c:	0505                	addi	a0,a0,1
    p2++;
 36e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 370:	fed518e3          	bne	a0,a3,360 <memcmp+0x14>
  }
  return 0;
 374:	4501                	li	a0,0
 376:	a019                	j	37c <memcmp+0x30>
      return *p1 - *p2;
 378:	40e7853b          	subw	a0,a5,a4
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret
  return 0;
 382:	4501                	li	a0,0
 384:	bfe5                	j	37c <memcmp+0x30>

0000000000000386 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 386:	1141                	addi	sp,sp,-16
 388:	e406                	sd	ra,8(sp)
 38a:	e022                	sd	s0,0(sp)
 38c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 38e:	00000097          	auipc	ra,0x0
 392:	f66080e7          	jalr	-154(ra) # 2f4 <memmove>
}
 396:	60a2                	ld	ra,8(sp)
 398:	6402                	ld	s0,0(sp)
 39a:	0141                	addi	sp,sp,16
 39c:	8082                	ret

000000000000039e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 39e:	4885                	li	a7,1
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a6:	4889                	li	a7,2
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ae:	488d                	li	a7,3
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b6:	4891                	li	a7,4
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <read>:
.global read
read:
 li a7, SYS_read
 3be:	4895                	li	a7,5
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <write>:
.global write
write:
 li a7, SYS_write
 3c6:	48c1                	li	a7,16
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <close>:
.global close
close:
 li a7, SYS_close
 3ce:	48d5                	li	a7,21
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d6:	4899                	li	a7,6
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <exec>:
.global exec
exec:
 li a7, SYS_exec
 3de:	489d                	li	a7,7
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <open>:
.global open
open:
 li a7, SYS_open
 3e6:	48bd                	li	a7,15
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ee:	48c5                	li	a7,17
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f6:	48c9                	li	a7,18
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3fe:	48a1                	li	a7,8
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <link>:
.global link
link:
 li a7, SYS_link
 406:	48cd                	li	a7,19
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 40e:	48d1                	li	a7,20
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 416:	48a5                	li	a7,9
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <dup>:
.global dup
dup:
 li a7, SYS_dup
 41e:	48a9                	li	a7,10
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 426:	48ad                	li	a7,11
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 42e:	48b1                	li	a7,12
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 436:	48b5                	li	a7,13
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 43e:	48b9                	li	a7,14
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <yield>:
.global yield
yield:
 li a7, SYS_yield
 446:	48d9                	li	a7,22
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <lock>:
.global lock
lock:
 li a7, SYS_lock
 44e:	48dd                	li	a7,23
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 456:	48e1                	li	a7,24
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45e:	1101                	addi	sp,sp,-32
 460:	ec06                	sd	ra,24(sp)
 462:	e822                	sd	s0,16(sp)
 464:	1000                	addi	s0,sp,32
 466:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46a:	4605                	li	a2,1
 46c:	fef40593          	addi	a1,s0,-17
 470:	00000097          	auipc	ra,0x0
 474:	f56080e7          	jalr	-170(ra) # 3c6 <write>
}
 478:	60e2                	ld	ra,24(sp)
 47a:	6442                	ld	s0,16(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret

0000000000000480 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	7139                	addi	sp,sp,-64
 482:	fc06                	sd	ra,56(sp)
 484:	f822                	sd	s0,48(sp)
 486:	f426                	sd	s1,40(sp)
 488:	0080                	addi	s0,sp,64
 48a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48c:	c299                	beqz	a3,492 <printint+0x12>
 48e:	0805cb63          	bltz	a1,524 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 492:	2581                	sext.w	a1,a1
  neg = 0;
 494:	4881                	li	a7,0
 496:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 49a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49c:	2601                	sext.w	a2,a2
 49e:	00000517          	auipc	a0,0x0
 4a2:	64250513          	addi	a0,a0,1602 # ae0 <digits>
 4a6:	883a                	mv	a6,a4
 4a8:	2705                	addiw	a4,a4,1
 4aa:	02c5f7bb          	remuw	a5,a1,a2
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	97aa                	add	a5,a5,a0
 4b4:	0007c783          	lbu	a5,0(a5)
 4b8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4bc:	0005879b          	sext.w	a5,a1
 4c0:	02c5d5bb          	divuw	a1,a1,a2
 4c4:	0685                	addi	a3,a3,1
 4c6:	fec7f0e3          	bgeu	a5,a2,4a6 <printint+0x26>
  if(neg)
 4ca:	00088c63          	beqz	a7,4e2 <printint+0x62>
    buf[i++] = '-';
 4ce:	fd070793          	addi	a5,a4,-48
 4d2:	00878733          	add	a4,a5,s0
 4d6:	02d00793          	li	a5,45
 4da:	fef70823          	sb	a5,-16(a4)
 4de:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e2:	02e05c63          	blez	a4,51a <printint+0x9a>
 4e6:	f04a                	sd	s2,32(sp)
 4e8:	ec4e                	sd	s3,24(sp)
 4ea:	fc040793          	addi	a5,s0,-64
 4ee:	00e78933          	add	s2,a5,a4
 4f2:	fff78993          	addi	s3,a5,-1
 4f6:	99ba                	add	s3,s3,a4
 4f8:	377d                	addiw	a4,a4,-1
 4fa:	1702                	slli	a4,a4,0x20
 4fc:	9301                	srli	a4,a4,0x20
 4fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 502:	fff94583          	lbu	a1,-1(s2)
 506:	8526                	mv	a0,s1
 508:	00000097          	auipc	ra,0x0
 50c:	f56080e7          	jalr	-170(ra) # 45e <putc>
  while(--i >= 0)
 510:	197d                	addi	s2,s2,-1
 512:	ff3918e3          	bne	s2,s3,502 <printint+0x82>
 516:	7902                	ld	s2,32(sp)
 518:	69e2                	ld	s3,24(sp)
}
 51a:	70e2                	ld	ra,56(sp)
 51c:	7442                	ld	s0,48(sp)
 51e:	74a2                	ld	s1,40(sp)
 520:	6121                	addi	sp,sp,64
 522:	8082                	ret
    x = -xx;
 524:	40b005bb          	negw	a1,a1
    neg = 1;
 528:	4885                	li	a7,1
    x = -xx;
 52a:	b7b5                	j	496 <printint+0x16>

000000000000052c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52c:	715d                	addi	sp,sp,-80
 52e:	e486                	sd	ra,72(sp)
 530:	e0a2                	sd	s0,64(sp)
 532:	f84a                	sd	s2,48(sp)
 534:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 536:	0005c903          	lbu	s2,0(a1)
 53a:	1a090a63          	beqz	s2,6ee <vprintf+0x1c2>
 53e:	fc26                	sd	s1,56(sp)
 540:	f44e                	sd	s3,40(sp)
 542:	f052                	sd	s4,32(sp)
 544:	ec56                	sd	s5,24(sp)
 546:	e85a                	sd	s6,16(sp)
 548:	e45e                	sd	s7,8(sp)
 54a:	8aaa                	mv	s5,a0
 54c:	8bb2                	mv	s7,a2
 54e:	00158493          	addi	s1,a1,1
  state = 0;
 552:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 554:	02500a13          	li	s4,37
 558:	4b55                	li	s6,21
 55a:	a839                	j	578 <vprintf+0x4c>
        putc(fd, c);
 55c:	85ca                	mv	a1,s2
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	efe080e7          	jalr	-258(ra) # 45e <putc>
 568:	a019                	j	56e <vprintf+0x42>
    } else if(state == '%'){
 56a:	01498d63          	beq	s3,s4,584 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 56e:	0485                	addi	s1,s1,1
 570:	fff4c903          	lbu	s2,-1(s1)
 574:	16090763          	beqz	s2,6e2 <vprintf+0x1b6>
    if(state == 0){
 578:	fe0999e3          	bnez	s3,56a <vprintf+0x3e>
      if(c == '%'){
 57c:	ff4910e3          	bne	s2,s4,55c <vprintf+0x30>
        state = '%';
 580:	89d2                	mv	s3,s4
 582:	b7f5                	j	56e <vprintf+0x42>
      if(c == 'd'){
 584:	13490463          	beq	s2,s4,6ac <vprintf+0x180>
 588:	f9d9079b          	addiw	a5,s2,-99
 58c:	0ff7f793          	zext.b	a5,a5
 590:	12fb6763          	bltu	s6,a5,6be <vprintf+0x192>
 594:	f9d9079b          	addiw	a5,s2,-99
 598:	0ff7f713          	zext.b	a4,a5
 59c:	12eb6163          	bltu	s6,a4,6be <vprintf+0x192>
 5a0:	00271793          	slli	a5,a4,0x2
 5a4:	00000717          	auipc	a4,0x0
 5a8:	4e470713          	addi	a4,a4,1252 # a88 <malloc+0x174>
 5ac:	97ba                	add	a5,a5,a4
 5ae:	439c                	lw	a5,0(a5)
 5b0:	97ba                	add	a5,a5,a4
 5b2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5b4:	008b8913          	addi	s2,s7,8
 5b8:	4685                	li	a3,1
 5ba:	4629                	li	a2,10
 5bc:	000ba583          	lw	a1,0(s7)
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	ebe080e7          	jalr	-322(ra) # 480 <printint>
 5ca:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b745                	j	56e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	ea2080e7          	jalr	-350(ra) # 480 <printint>
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b751                	j	56e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4641                	li	a2,16
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	e86080e7          	jalr	-378(ra) # 480 <printint>
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
 606:	b7a5                	j	56e <vprintf+0x42>
 608:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 60a:	008b8c13          	addi	s8,s7,8
 60e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 612:	03000593          	li	a1,48
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	e46080e7          	jalr	-442(ra) # 45e <putc>
  putc(fd, 'x');
 620:	07800593          	li	a1,120
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	e38080e7          	jalr	-456(ra) # 45e <putc>
 62e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 630:	00000b97          	auipc	s7,0x0
 634:	4b0b8b93          	addi	s7,s7,1200 # ae0 <digits>
 638:	03c9d793          	srli	a5,s3,0x3c
 63c:	97de                	add	a5,a5,s7
 63e:	0007c583          	lbu	a1,0(a5)
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e1a080e7          	jalr	-486(ra) # 45e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64c:	0992                	slli	s3,s3,0x4
 64e:	397d                	addiw	s2,s2,-1
 650:	fe0914e3          	bnez	s2,638 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 654:	8be2                	mv	s7,s8
      state = 0;
 656:	4981                	li	s3,0
 658:	6c02                	ld	s8,0(sp)
 65a:	bf11                	j	56e <vprintf+0x42>
        s = va_arg(ap, char*);
 65c:	008b8993          	addi	s3,s7,8
 660:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 664:	02090163          	beqz	s2,686 <vprintf+0x15a>
        while(*s != 0){
 668:	00094583          	lbu	a1,0(s2)
 66c:	c9a5                	beqz	a1,6dc <vprintf+0x1b0>
          putc(fd, *s);
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	dee080e7          	jalr	-530(ra) # 45e <putc>
          s++;
 678:	0905                	addi	s2,s2,1
        while(*s != 0){
 67a:	00094583          	lbu	a1,0(s2)
 67e:	f9e5                	bnez	a1,66e <vprintf+0x142>
        s = va_arg(ap, char*);
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	b5ed                	j	56e <vprintf+0x42>
          s = "(null)";
 686:	00000917          	auipc	s2,0x0
 68a:	3fa90913          	addi	s2,s2,1018 # a80 <malloc+0x16c>
        while(*s != 0){
 68e:	02800593          	li	a1,40
 692:	bff1                	j	66e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 694:	008b8913          	addi	s2,s7,8
 698:	000bc583          	lbu	a1,0(s7)
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	dc0080e7          	jalr	-576(ra) # 45e <putc>
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b5d1                	j	56e <vprintf+0x42>
        putc(fd, c);
 6ac:	02500593          	li	a1,37
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	dac080e7          	jalr	-596(ra) # 45e <putc>
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bd4d                	j	56e <vprintf+0x42>
        putc(fd, '%');
 6be:	02500593          	li	a1,37
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	d9a080e7          	jalr	-614(ra) # 45e <putc>
        putc(fd, c);
 6cc:	85ca                	mv	a1,s2
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	d8e080e7          	jalr	-626(ra) # 45e <putc>
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bd51                	j	56e <vprintf+0x42>
        s = va_arg(ap, char*);
 6dc:	8bce                	mv	s7,s3
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b579                	j	56e <vprintf+0x42>
 6e2:	74e2                	ld	s1,56(sp)
 6e4:	79a2                	ld	s3,40(sp)
 6e6:	7a02                	ld	s4,32(sp)
 6e8:	6ae2                	ld	s5,24(sp)
 6ea:	6b42                	ld	s6,16(sp)
 6ec:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6ee:	60a6                	ld	ra,72(sp)
 6f0:	6406                	ld	s0,64(sp)
 6f2:	7942                	ld	s2,48(sp)
 6f4:	6161                	addi	sp,sp,80
 6f6:	8082                	ret

00000000000006f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f8:	715d                	addi	sp,sp,-80
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	e010                	sd	a2,0(s0)
 702:	e414                	sd	a3,8(s0)
 704:	e818                	sd	a4,16(s0)
 706:	ec1c                	sd	a5,24(s0)
 708:	03043023          	sd	a6,32(s0)
 70c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 710:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 714:	8622                	mv	a2,s0
 716:	00000097          	auipc	ra,0x0
 71a:	e16080e7          	jalr	-490(ra) # 52c <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6161                	addi	sp,sp,80
 724:	8082                	ret

0000000000000726 <printf>:

void
printf(const char *fmt, ...)
{
 726:	7159                	addi	sp,sp,-112
 728:	f406                	sd	ra,40(sp)
 72a:	f022                	sd	s0,32(sp)
 72c:	ec26                	sd	s1,24(sp)
 72e:	1800                	addi	s0,sp,48
 730:	84aa                	mv	s1,a0
 732:	e40c                	sd	a1,8(s0)
 734:	e810                	sd	a2,16(s0)
 736:	ec14                	sd	a3,24(s0)
 738:	f018                	sd	a4,32(s0)
 73a:	f41c                	sd	a5,40(s0)
 73c:	03043823          	sd	a6,48(s0)
 740:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 744:	00000097          	auipc	ra,0x0
 748:	d0a080e7          	jalr	-758(ra) # 44e <lock>
  va_start(ap, fmt);
 74c:	00840613          	addi	a2,s0,8
 750:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 754:	85a6                	mv	a1,s1
 756:	4505                	li	a0,1
 758:	00000097          	auipc	ra,0x0
 75c:	dd4080e7          	jalr	-556(ra) # 52c <vprintf>
  unlock();
 760:	00000097          	auipc	ra,0x0
 764:	cf6080e7          	jalr	-778(ra) # 456 <unlock>
}
 768:	70a2                	ld	ra,40(sp)
 76a:	7402                	ld	s0,32(sp)
 76c:	64e2                	ld	s1,24(sp)
 76e:	6165                	addi	sp,sp,112
 770:	8082                	ret

0000000000000772 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 772:	7179                	addi	sp,sp,-48
 774:	f422                	sd	s0,40(sp)
 776:	1800                	addi	s0,sp,48
 778:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77c:	fd843783          	ld	a5,-40(s0)
 780:	17c1                	addi	a5,a5,-16
 782:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 786:	00001797          	auipc	a5,0x1
 78a:	c4a78793          	addi	a5,a5,-950 # 13d0 <freep>
 78e:	639c                	ld	a5,0(a5)
 790:	fef43423          	sd	a5,-24(s0)
 794:	a815                	j	7c8 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 796:	fe843783          	ld	a5,-24(s0)
 79a:	639c                	ld	a5,0(a5)
 79c:	fe843703          	ld	a4,-24(s0)
 7a0:	00f76f63          	bltu	a4,a5,7be <free+0x4c>
 7a4:	fe043703          	ld	a4,-32(s0)
 7a8:	fe843783          	ld	a5,-24(s0)
 7ac:	02e7eb63          	bltu	a5,a4,7e2 <free+0x70>
 7b0:	fe843783          	ld	a5,-24(s0)
 7b4:	639c                	ld	a5,0(a5)
 7b6:	fe043703          	ld	a4,-32(s0)
 7ba:	02f76463          	bltu	a4,a5,7e2 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	fe843783          	ld	a5,-24(s0)
 7c2:	639c                	ld	a5,0(a5)
 7c4:	fef43423          	sd	a5,-24(s0)
 7c8:	fe043703          	ld	a4,-32(s0)
 7cc:	fe843783          	ld	a5,-24(s0)
 7d0:	fce7f3e3          	bgeu	a5,a4,796 <free+0x24>
 7d4:	fe843783          	ld	a5,-24(s0)
 7d8:	639c                	ld	a5,0(a5)
 7da:	fe043703          	ld	a4,-32(s0)
 7de:	faf77ce3          	bgeu	a4,a5,796 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e2:	fe043783          	ld	a5,-32(s0)
 7e6:	479c                	lw	a5,8(a5)
 7e8:	1782                	slli	a5,a5,0x20
 7ea:	9381                	srli	a5,a5,0x20
 7ec:	0792                	slli	a5,a5,0x4
 7ee:	fe043703          	ld	a4,-32(s0)
 7f2:	973e                	add	a4,a4,a5
 7f4:	fe843783          	ld	a5,-24(s0)
 7f8:	639c                	ld	a5,0(a5)
 7fa:	02f71763          	bne	a4,a5,828 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 7fe:	fe043783          	ld	a5,-32(s0)
 802:	4798                	lw	a4,8(a5)
 804:	fe843783          	ld	a5,-24(s0)
 808:	639c                	ld	a5,0(a5)
 80a:	479c                	lw	a5,8(a5)
 80c:	9fb9                	addw	a5,a5,a4
 80e:	0007871b          	sext.w	a4,a5
 812:	fe043783          	ld	a5,-32(s0)
 816:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 818:	fe843783          	ld	a5,-24(s0)
 81c:	639c                	ld	a5,0(a5)
 81e:	6398                	ld	a4,0(a5)
 820:	fe043783          	ld	a5,-32(s0)
 824:	e398                	sd	a4,0(a5)
 826:	a039                	j	834 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 828:	fe843783          	ld	a5,-24(s0)
 82c:	6398                	ld	a4,0(a5)
 82e:	fe043783          	ld	a5,-32(s0)
 832:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 834:	fe843783          	ld	a5,-24(s0)
 838:	479c                	lw	a5,8(a5)
 83a:	1782                	slli	a5,a5,0x20
 83c:	9381                	srli	a5,a5,0x20
 83e:	0792                	slli	a5,a5,0x4
 840:	fe843703          	ld	a4,-24(s0)
 844:	97ba                	add	a5,a5,a4
 846:	fe043703          	ld	a4,-32(s0)
 84a:	02f71563          	bne	a4,a5,874 <free+0x102>
    p->s.size += bp->s.size;
 84e:	fe843783          	ld	a5,-24(s0)
 852:	4798                	lw	a4,8(a5)
 854:	fe043783          	ld	a5,-32(s0)
 858:	479c                	lw	a5,8(a5)
 85a:	9fb9                	addw	a5,a5,a4
 85c:	0007871b          	sext.w	a4,a5
 860:	fe843783          	ld	a5,-24(s0)
 864:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 866:	fe043783          	ld	a5,-32(s0)
 86a:	6398                	ld	a4,0(a5)
 86c:	fe843783          	ld	a5,-24(s0)
 870:	e398                	sd	a4,0(a5)
 872:	a031                	j	87e <free+0x10c>
  } else
    p->s.ptr = bp;
 874:	fe843783          	ld	a5,-24(s0)
 878:	fe043703          	ld	a4,-32(s0)
 87c:	e398                	sd	a4,0(a5)
  freep = p;
 87e:	00001797          	auipc	a5,0x1
 882:	b5278793          	addi	a5,a5,-1198 # 13d0 <freep>
 886:	fe843703          	ld	a4,-24(s0)
 88a:	e398                	sd	a4,0(a5)
}
 88c:	0001                	nop
 88e:	7422                	ld	s0,40(sp)
 890:	6145                	addi	sp,sp,48
 892:	8082                	ret

0000000000000894 <morecore>:

static Header*
morecore(uint nu)
{
 894:	7179                	addi	sp,sp,-48
 896:	f406                	sd	ra,40(sp)
 898:	f022                	sd	s0,32(sp)
 89a:	1800                	addi	s0,sp,48
 89c:	87aa                	mv	a5,a0
 89e:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 8a2:	fdc42783          	lw	a5,-36(s0)
 8a6:	0007871b          	sext.w	a4,a5
 8aa:	6785                	lui	a5,0x1
 8ac:	00f77563          	bgeu	a4,a5,8b6 <morecore+0x22>
    nu = 4096;
 8b0:	6785                	lui	a5,0x1
 8b2:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 8b6:	fdc42783          	lw	a5,-36(s0)
 8ba:	0047979b          	slliw	a5,a5,0x4
 8be:	2781                	sext.w	a5,a5
 8c0:	2781                	sext.w	a5,a5
 8c2:	853e                	mv	a0,a5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	b6a080e7          	jalr	-1174(ra) # 42e <sbrk>
 8cc:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 8d0:	fe843703          	ld	a4,-24(s0)
 8d4:	57fd                	li	a5,-1
 8d6:	00f71463          	bne	a4,a5,8de <morecore+0x4a>
    return 0;
 8da:	4781                	li	a5,0
 8dc:	a03d                	j	90a <morecore+0x76>
  hp = (Header*)p;
 8de:	fe843783          	ld	a5,-24(s0)
 8e2:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 8e6:	fe043783          	ld	a5,-32(s0)
 8ea:	fdc42703          	lw	a4,-36(s0)
 8ee:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 8f0:	fe043783          	ld	a5,-32(s0)
 8f4:	07c1                	addi	a5,a5,16 # 1010 <digits+0x530>
 8f6:	853e                	mv	a0,a5
 8f8:	00000097          	auipc	ra,0x0
 8fc:	e7a080e7          	jalr	-390(ra) # 772 <free>
  return freep;
 900:	00001797          	auipc	a5,0x1
 904:	ad078793          	addi	a5,a5,-1328 # 13d0 <freep>
 908:	639c                	ld	a5,0(a5)
}
 90a:	853e                	mv	a0,a5
 90c:	70a2                	ld	ra,40(sp)
 90e:	7402                	ld	s0,32(sp)
 910:	6145                	addi	sp,sp,48
 912:	8082                	ret

0000000000000914 <malloc>:

void*
malloc(uint nbytes)
{
 914:	7139                	addi	sp,sp,-64
 916:	fc06                	sd	ra,56(sp)
 918:	f822                	sd	s0,48(sp)
 91a:	0080                	addi	s0,sp,64
 91c:	87aa                	mv	a5,a0
 91e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 922:	fcc46783          	lwu	a5,-52(s0)
 926:	07bd                	addi	a5,a5,15
 928:	8391                	srli	a5,a5,0x4
 92a:	2781                	sext.w	a5,a5
 92c:	2785                	addiw	a5,a5,1
 92e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 932:	00001797          	auipc	a5,0x1
 936:	a9e78793          	addi	a5,a5,-1378 # 13d0 <freep>
 93a:	639c                	ld	a5,0(a5)
 93c:	fef43023          	sd	a5,-32(s0)
 940:	fe043783          	ld	a5,-32(s0)
 944:	ef95                	bnez	a5,980 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 946:	00001797          	auipc	a5,0x1
 94a:	a7a78793          	addi	a5,a5,-1414 # 13c0 <base>
 94e:	fef43023          	sd	a5,-32(s0)
 952:	00001797          	auipc	a5,0x1
 956:	a7e78793          	addi	a5,a5,-1410 # 13d0 <freep>
 95a:	fe043703          	ld	a4,-32(s0)
 95e:	e398                	sd	a4,0(a5)
 960:	00001797          	auipc	a5,0x1
 964:	a7078793          	addi	a5,a5,-1424 # 13d0 <freep>
 968:	6398                	ld	a4,0(a5)
 96a:	00001797          	auipc	a5,0x1
 96e:	a5678793          	addi	a5,a5,-1450 # 13c0 <base>
 972:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 974:	00001797          	auipc	a5,0x1
 978:	a4c78793          	addi	a5,a5,-1460 # 13c0 <base>
 97c:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 980:	fe043783          	ld	a5,-32(s0)
 984:	639c                	ld	a5,0(a5)
 986:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 98a:	fe843783          	ld	a5,-24(s0)
 98e:	4798                	lw	a4,8(a5)
 990:	fdc42783          	lw	a5,-36(s0)
 994:	2781                	sext.w	a5,a5
 996:	06f76763          	bltu	a4,a5,a04 <malloc+0xf0>
      if(p->s.size == nunits)
 99a:	fe843783          	ld	a5,-24(s0)
 99e:	4798                	lw	a4,8(a5)
 9a0:	fdc42783          	lw	a5,-36(s0)
 9a4:	2781                	sext.w	a5,a5
 9a6:	00e79963          	bne	a5,a4,9b8 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 9aa:	fe843783          	ld	a5,-24(s0)
 9ae:	6398                	ld	a4,0(a5)
 9b0:	fe043783          	ld	a5,-32(s0)
 9b4:	e398                	sd	a4,0(a5)
 9b6:	a825                	j	9ee <malloc+0xda>
      else {
        p->s.size -= nunits;
 9b8:	fe843783          	ld	a5,-24(s0)
 9bc:	479c                	lw	a5,8(a5)
 9be:	fdc42703          	lw	a4,-36(s0)
 9c2:	9f99                	subw	a5,a5,a4
 9c4:	0007871b          	sext.w	a4,a5
 9c8:	fe843783          	ld	a5,-24(s0)
 9cc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ce:	fe843783          	ld	a5,-24(s0)
 9d2:	479c                	lw	a5,8(a5)
 9d4:	1782                	slli	a5,a5,0x20
 9d6:	9381                	srli	a5,a5,0x20
 9d8:	0792                	slli	a5,a5,0x4
 9da:	fe843703          	ld	a4,-24(s0)
 9de:	97ba                	add	a5,a5,a4
 9e0:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 9e4:	fe843783          	ld	a5,-24(s0)
 9e8:	fdc42703          	lw	a4,-36(s0)
 9ec:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 9ee:	00001797          	auipc	a5,0x1
 9f2:	9e278793          	addi	a5,a5,-1566 # 13d0 <freep>
 9f6:	fe043703          	ld	a4,-32(s0)
 9fa:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 9fc:	fe843783          	ld	a5,-24(s0)
 a00:	07c1                	addi	a5,a5,16
 a02:	a091                	j	a46 <malloc+0x132>
    }
    if(p == freep)
 a04:	00001797          	auipc	a5,0x1
 a08:	9cc78793          	addi	a5,a5,-1588 # 13d0 <freep>
 a0c:	639c                	ld	a5,0(a5)
 a0e:	fe843703          	ld	a4,-24(s0)
 a12:	02f71063          	bne	a4,a5,a32 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 a16:	fdc42783          	lw	a5,-36(s0)
 a1a:	853e                	mv	a0,a5
 a1c:	00000097          	auipc	ra,0x0
 a20:	e78080e7          	jalr	-392(ra) # 894 <morecore>
 a24:	fea43423          	sd	a0,-24(s0)
 a28:	fe843783          	ld	a5,-24(s0)
 a2c:	e399                	bnez	a5,a32 <malloc+0x11e>
        return 0;
 a2e:	4781                	li	a5,0
 a30:	a819                	j	a46 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a32:	fe843783          	ld	a5,-24(s0)
 a36:	fef43023          	sd	a5,-32(s0)
 a3a:	fe843783          	ld	a5,-24(s0)
 a3e:	639c                	ld	a5,0(a5)
 a40:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 a44:	b799                	j	98a <malloc+0x76>
  }
}
 a46:	853e                	mv	a0,a5
 a48:	70e2                	ld	ra,56(sp)
 a4a:	7442                	ld	s0,48(sp)
 a4c:	6121                	addi	sp,sp,64
 a4e:	8082                	ret
