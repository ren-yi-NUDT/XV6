
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	332080e7          	jalr	818(ra) # 33e <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	306080e7          	jalr	774(ra) # 33e <strlen>
  40:	2501                	sext.w	a0,a0
  42:	47b5                	li	a5,13
  44:	00a7f863          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  48:	8526                	mv	a0,s1
  4a:	70a2                	ld	ra,40(sp)
  4c:	7402                	ld	s0,32(sp)
  4e:	64e2                	ld	s1,24(sp)
  50:	6145                	addi	sp,sp,48
  52:	8082                	ret
  54:	e84a                	sd	s2,16(sp)
  56:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  58:	8526                	mv	a0,s1
  5a:	00000097          	auipc	ra,0x0
  5e:	2e4080e7          	jalr	740(ra) # 33e <strlen>
  62:	00001997          	auipc	s3,0x1
  66:	3de98993          	addi	s3,s3,990 # 1440 <buf.0>
  6a:	0005061b          	sext.w	a2,a0
  6e:	85a6                	mv	a1,s1
  70:	854e                	mv	a0,s3
  72:	00000097          	auipc	ra,0x0
  76:	43e080e7          	jalr	1086(ra) # 4b0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7a:	8526                	mv	a0,s1
  7c:	00000097          	auipc	ra,0x0
  80:	2c2080e7          	jalr	706(ra) # 33e <strlen>
  84:	0005091b          	sext.w	s2,a0
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	2b4080e7          	jalr	692(ra) # 33e <strlen>
  92:	1902                	slli	s2,s2,0x20
  94:	02095913          	srli	s2,s2,0x20
  98:	4639                	li	a2,14
  9a:	9e09                	subw	a2,a2,a0
  9c:	02000593          	li	a1,32
  a0:	01298533          	add	a0,s3,s2
  a4:	00000097          	auipc	ra,0x0
  a8:	2c4080e7          	jalr	708(ra) # 368 <memset>
  return buf;
  ac:	84ce                	mv	s1,s3
  ae:	6942                	ld	s2,16(sp)
  b0:	69a2                	ld	s3,8(sp)
  b2:	bf59                	j	48 <fmtname+0x48>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	25213823          	sd	s2,592(sp)
  c4:	1c80                	addi	s0,sp,624
  c6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c8:	4581                	li	a1,0
  ca:	00000097          	auipc	ra,0x0
  ce:	4d8080e7          	jalr	1240(ra) # 5a2 <open>
  d2:	06054b63          	bltz	a0,148 <ls+0x94>
  d6:	24913c23          	sd	s1,600(sp)
  da:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  dc:	d9840593          	addi	a1,s0,-616
  e0:	00000097          	auipc	ra,0x0
  e4:	4da080e7          	jalr	1242(ra) # 5ba <fstat>
  e8:	06054b63          	bltz	a0,15e <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  ec:	da041783          	lh	a5,-608(s0)
  f0:	4705                	li	a4,1
  f2:	08e78863          	beq	a5,a4,182 <ls+0xce>
  f6:	37f9                	addiw	a5,a5,-2
  f8:	17c2                	slli	a5,a5,0x30
  fa:	93c1                	srli	a5,a5,0x30
  fc:	02f76663          	bltu	a4,a5,128 <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 100:	854a                	mv	a0,s2
 102:	00000097          	auipc	ra,0x0
 106:	efe080e7          	jalr	-258(ra) # 0 <fmtname>
 10a:	85aa                	mv	a1,a0
 10c:	da843703          	ld	a4,-600(s0)
 110:	d9c42683          	lw	a3,-612(s0)
 114:	da041603          	lh	a2,-608(s0)
 118:	00001517          	auipc	a0,0x1
 11c:	b2850513          	addi	a0,a0,-1240 # c40 <malloc+0x170>
 120:	00000097          	auipc	ra,0x0
 124:	7c2080e7          	jalr	1986(ra) # 8e2 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 128:	8526                	mv	a0,s1
 12a:	00000097          	auipc	ra,0x0
 12e:	460080e7          	jalr	1120(ra) # 58a <close>
 132:	25813483          	ld	s1,600(sp)
}
 136:	26813083          	ld	ra,616(sp)
 13a:	26013403          	ld	s0,608(sp)
 13e:	25013903          	ld	s2,592(sp)
 142:	27010113          	addi	sp,sp,624
 146:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 148:	864a                	mv	a2,s2
 14a:	00001597          	auipc	a1,0x1
 14e:	ac658593          	addi	a1,a1,-1338 # c10 <malloc+0x140>
 152:	4509                	li	a0,2
 154:	00000097          	auipc	ra,0x0
 158:	760080e7          	jalr	1888(ra) # 8b4 <fprintf>
    return;
 15c:	bfe9                	j	136 <ls+0x82>
    fprintf(2, "ls: cannot stat %s\n", path);
 15e:	864a                	mv	a2,s2
 160:	00001597          	auipc	a1,0x1
 164:	ac858593          	addi	a1,a1,-1336 # c28 <malloc+0x158>
 168:	4509                	li	a0,2
 16a:	00000097          	auipc	ra,0x0
 16e:	74a080e7          	jalr	1866(ra) # 8b4 <fprintf>
    close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	416080e7          	jalr	1046(ra) # 58a <close>
    return;
 17c:	25813483          	ld	s1,600(sp)
 180:	bf5d                	j	136 <ls+0x82>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 182:	854a                	mv	a0,s2
 184:	00000097          	auipc	ra,0x0
 188:	1ba080e7          	jalr	442(ra) # 33e <strlen>
 18c:	2541                	addiw	a0,a0,16
 18e:	20000793          	li	a5,512
 192:	00a7fb63          	bgeu	a5,a0,1a8 <ls+0xf4>
      printf("ls: path too long\n");
 196:	00001517          	auipc	a0,0x1
 19a:	aba50513          	addi	a0,a0,-1350 # c50 <malloc+0x180>
 19e:	00000097          	auipc	ra,0x0
 1a2:	744080e7          	jalr	1860(ra) # 8e2 <printf>
      break;
 1a6:	b749                	j	128 <ls+0x74>
 1a8:	25313423          	sd	s3,584(sp)
 1ac:	25413023          	sd	s4,576(sp)
 1b0:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 1b4:	85ca                	mv	a1,s2
 1b6:	dc040513          	addi	a0,s0,-576
 1ba:	00000097          	auipc	ra,0x0
 1be:	13c080e7          	jalr	316(ra) # 2f6 <strcpy>
    p = buf+strlen(buf);
 1c2:	dc040513          	addi	a0,s0,-576
 1c6:	00000097          	auipc	ra,0x0
 1ca:	178080e7          	jalr	376(ra) # 33e <strlen>
 1ce:	1502                	slli	a0,a0,0x20
 1d0:	9101                	srli	a0,a0,0x20
 1d2:	dc040793          	addi	a5,s0,-576
 1d6:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1da:	00190993          	addi	s3,s2,1
 1de:	02f00793          	li	a5,47
 1e2:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1e6:	00001a17          	auipc	s4,0x1
 1ea:	a82a0a13          	addi	s4,s4,-1406 # c68 <malloc+0x198>
        printf("ls: cannot stat %s\n", buf);
 1ee:	00001a97          	auipc	s5,0x1
 1f2:	a3aa8a93          	addi	s5,s5,-1478 # c28 <malloc+0x158>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f6:	a801                	j	206 <ls+0x152>
        printf("ls: cannot stat %s\n", buf);
 1f8:	dc040593          	addi	a1,s0,-576
 1fc:	8556                	mv	a0,s5
 1fe:	00000097          	auipc	ra,0x0
 202:	6e4080e7          	jalr	1764(ra) # 8e2 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 206:	4641                	li	a2,16
 208:	db040593          	addi	a1,s0,-592
 20c:	8526                	mv	a0,s1
 20e:	00000097          	auipc	ra,0x0
 212:	36c080e7          	jalr	876(ra) # 57a <read>
 216:	47c1                	li	a5,16
 218:	04f51c63          	bne	a0,a5,270 <ls+0x1bc>
      if(de.inum == 0)
 21c:	db045783          	lhu	a5,-592(s0)
 220:	d3fd                	beqz	a5,206 <ls+0x152>
      memmove(p, de.name, DIRSIZ);
 222:	4639                	li	a2,14
 224:	db240593          	addi	a1,s0,-590
 228:	854e                	mv	a0,s3
 22a:	00000097          	auipc	ra,0x0
 22e:	286080e7          	jalr	646(ra) # 4b0 <memmove>
      p[DIRSIZ] = 0;
 232:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 236:	d9840593          	addi	a1,s0,-616
 23a:	dc040513          	addi	a0,s0,-576
 23e:	00000097          	auipc	ra,0x0
 242:	1e4080e7          	jalr	484(ra) # 422 <stat>
 246:	fa0549e3          	bltz	a0,1f8 <ls+0x144>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 24a:	dc040513          	addi	a0,s0,-576
 24e:	00000097          	auipc	ra,0x0
 252:	db2080e7          	jalr	-590(ra) # 0 <fmtname>
 256:	85aa                	mv	a1,a0
 258:	da843703          	ld	a4,-600(s0)
 25c:	d9c42683          	lw	a3,-612(s0)
 260:	da041603          	lh	a2,-608(s0)
 264:	8552                	mv	a0,s4
 266:	00000097          	auipc	ra,0x0
 26a:	67c080e7          	jalr	1660(ra) # 8e2 <printf>
 26e:	bf61                	j	206 <ls+0x152>
 270:	24813983          	ld	s3,584(sp)
 274:	24013a03          	ld	s4,576(sp)
 278:	23813a83          	ld	s5,568(sp)
 27c:	b575                	j	128 <ls+0x74>

000000000000027e <main>:

int
main(int argc, char *argv[])
{
 27e:	1101                	addi	sp,sp,-32
 280:	ec06                	sd	ra,24(sp)
 282:	e822                	sd	s0,16(sp)
 284:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 286:	4785                	li	a5,1
 288:	02a7db63          	bge	a5,a0,2be <main+0x40>
 28c:	e426                	sd	s1,8(sp)
 28e:	e04a                	sd	s2,0(sp)
 290:	00858493          	addi	s1,a1,8
 294:	ffe5091b          	addiw	s2,a0,-2
 298:	02091793          	slli	a5,s2,0x20
 29c:	01d7d913          	srli	s2,a5,0x1d
 2a0:	05c1                	addi	a1,a1,16
 2a2:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a4:	6088                	ld	a0,0(s1)
 2a6:	00000097          	auipc	ra,0x0
 2aa:	e0e080e7          	jalr	-498(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2ae:	04a1                	addi	s1,s1,8
 2b0:	ff249ae3          	bne	s1,s2,2a4 <main+0x26>
  exit(0);
 2b4:	4501                	li	a0,0
 2b6:	00000097          	auipc	ra,0x0
 2ba:	2ac080e7          	jalr	684(ra) # 562 <exit>
 2be:	e426                	sd	s1,8(sp)
 2c0:	e04a                	sd	s2,0(sp)
    ls(".");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	9b650513          	addi	a0,a0,-1610 # c78 <malloc+0x1a8>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	dea080e7          	jalr	-534(ra) # b4 <ls>
    exit(0);
 2d2:	4501                	li	a0,0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	28e080e7          	jalr	654(ra) # 562 <exit>

00000000000002dc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2e4:	00000097          	auipc	ra,0x0
 2e8:	f9a080e7          	jalr	-102(ra) # 27e <main>
  exit(0);
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	274080e7          	jalr	628(ra) # 562 <exit>

00000000000002f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2fc:	87aa                	mv	a5,a0
 2fe:	0585                	addi	a1,a1,1
 300:	0785                	addi	a5,a5,1
 302:	fff5c703          	lbu	a4,-1(a1)
 306:	fee78fa3          	sb	a4,-1(a5)
 30a:	fb75                	bnez	a4,2fe <strcpy+0x8>
    ;
  return os;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret

0000000000000312 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 318:	00054783          	lbu	a5,0(a0)
 31c:	cb91                	beqz	a5,330 <strcmp+0x1e>
 31e:	0005c703          	lbu	a4,0(a1)
 322:	00f71763          	bne	a4,a5,330 <strcmp+0x1e>
    p++, q++;
 326:	0505                	addi	a0,a0,1
 328:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 32a:	00054783          	lbu	a5,0(a0)
 32e:	fbe5                	bnez	a5,31e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 330:	0005c503          	lbu	a0,0(a1)
}
 334:	40a7853b          	subw	a0,a5,a0
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <strlen>:

uint
strlen(const char *s)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 344:	00054783          	lbu	a5,0(a0)
 348:	cf91                	beqz	a5,364 <strlen+0x26>
 34a:	0505                	addi	a0,a0,1
 34c:	87aa                	mv	a5,a0
 34e:	86be                	mv	a3,a5
 350:	0785                	addi	a5,a5,1
 352:	fff7c703          	lbu	a4,-1(a5)
 356:	ff65                	bnez	a4,34e <strlen+0x10>
 358:	40a6853b          	subw	a0,a3,a0
 35c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  for(n = 0; s[n]; n++)
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <strlen+0x20>

0000000000000368 <memset>:

void*
memset(void *dst, int c, uint n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 36e:	ca19                	beqz	a2,384 <memset+0x1c>
 370:	87aa                	mv	a5,a0
 372:	1602                	slli	a2,a2,0x20
 374:	9201                	srli	a2,a2,0x20
 376:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 37a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 37e:	0785                	addi	a5,a5,1
 380:	fee79de3          	bne	a5,a4,37a <memset+0x12>
  }
  return dst;
}
 384:	6422                	ld	s0,8(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <strchr>:

char*
strchr(const char *s, char c)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e422                	sd	s0,8(sp)
 38e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 390:	00054783          	lbu	a5,0(a0)
 394:	cb99                	beqz	a5,3aa <strchr+0x20>
    if(*s == c)
 396:	00f58763          	beq	a1,a5,3a4 <strchr+0x1a>
  for(; *s; s++)
 39a:	0505                	addi	a0,a0,1
 39c:	00054783          	lbu	a5,0(a0)
 3a0:	fbfd                	bnez	a5,396 <strchr+0xc>
      return (char*)s;
  return 0;
 3a2:	4501                	li	a0,0
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	bfe5                	j	3a4 <strchr+0x1a>

00000000000003ae <gets>:

char*
gets(char *buf, int max)
{
 3ae:	711d                	addi	sp,sp,-96
 3b0:	ec86                	sd	ra,88(sp)
 3b2:	e8a2                	sd	s0,80(sp)
 3b4:	e4a6                	sd	s1,72(sp)
 3b6:	e0ca                	sd	s2,64(sp)
 3b8:	fc4e                	sd	s3,56(sp)
 3ba:	f852                	sd	s4,48(sp)
 3bc:	f456                	sd	s5,40(sp)
 3be:	f05a                	sd	s6,32(sp)
 3c0:	ec5e                	sd	s7,24(sp)
 3c2:	1080                	addi	s0,sp,96
 3c4:	8baa                	mv	s7,a0
 3c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c8:	892a                	mv	s2,a0
 3ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3cc:	4aa9                	li	s5,10
 3ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3d0:	89a6                	mv	s3,s1
 3d2:	2485                	addiw	s1,s1,1
 3d4:	0344d863          	bge	s1,s4,404 <gets+0x56>
    cc = read(0, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	faf40593          	addi	a1,s0,-81
 3de:	4501                	li	a0,0
 3e0:	00000097          	auipc	ra,0x0
 3e4:	19a080e7          	jalr	410(ra) # 57a <read>
    if(cc < 1)
 3e8:	00a05e63          	blez	a0,404 <gets+0x56>
    buf[i++] = c;
 3ec:	faf44783          	lbu	a5,-81(s0)
 3f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3f4:	01578763          	beq	a5,s5,402 <gets+0x54>
 3f8:	0905                	addi	s2,s2,1
 3fa:	fd679be3          	bne	a5,s6,3d0 <gets+0x22>
    buf[i++] = c;
 3fe:	89a6                	mv	s3,s1
 400:	a011                	j	404 <gets+0x56>
 402:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 404:	99de                	add	s3,s3,s7
 406:	00098023          	sb	zero,0(s3)
  return buf;
}
 40a:	855e                	mv	a0,s7
 40c:	60e6                	ld	ra,88(sp)
 40e:	6446                	ld	s0,80(sp)
 410:	64a6                	ld	s1,72(sp)
 412:	6906                	ld	s2,64(sp)
 414:	79e2                	ld	s3,56(sp)
 416:	7a42                	ld	s4,48(sp)
 418:	7aa2                	ld	s5,40(sp)
 41a:	7b02                	ld	s6,32(sp)
 41c:	6be2                	ld	s7,24(sp)
 41e:	6125                	addi	sp,sp,96
 420:	8082                	ret

0000000000000422 <stat>:

int
stat(const char *n, struct stat *st)
{
 422:	1101                	addi	sp,sp,-32
 424:	ec06                	sd	ra,24(sp)
 426:	e822                	sd	s0,16(sp)
 428:	e04a                	sd	s2,0(sp)
 42a:	1000                	addi	s0,sp,32
 42c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42e:	4581                	li	a1,0
 430:	00000097          	auipc	ra,0x0
 434:	172080e7          	jalr	370(ra) # 5a2 <open>
  if(fd < 0)
 438:	02054663          	bltz	a0,464 <stat+0x42>
 43c:	e426                	sd	s1,8(sp)
 43e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 440:	85ca                	mv	a1,s2
 442:	00000097          	auipc	ra,0x0
 446:	178080e7          	jalr	376(ra) # 5ba <fstat>
 44a:	892a                	mv	s2,a0
  close(fd);
 44c:	8526                	mv	a0,s1
 44e:	00000097          	auipc	ra,0x0
 452:	13c080e7          	jalr	316(ra) # 58a <close>
  return r;
 456:	64a2                	ld	s1,8(sp)
}
 458:	854a                	mv	a0,s2
 45a:	60e2                	ld	ra,24(sp)
 45c:	6442                	ld	s0,16(sp)
 45e:	6902                	ld	s2,0(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret
    return -1;
 464:	597d                	li	s2,-1
 466:	bfcd                	j	458 <stat+0x36>

0000000000000468 <atoi>:

int
atoi(const char *s)
{
 468:	1141                	addi	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 46e:	00054683          	lbu	a3,0(a0)
 472:	fd06879b          	addiw	a5,a3,-48
 476:	0ff7f793          	zext.b	a5,a5
 47a:	4625                	li	a2,9
 47c:	02f66863          	bltu	a2,a5,4ac <atoi+0x44>
 480:	872a                	mv	a4,a0
  n = 0;
 482:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 484:	0705                	addi	a4,a4,1
 486:	0025179b          	slliw	a5,a0,0x2
 48a:	9fa9                	addw	a5,a5,a0
 48c:	0017979b          	slliw	a5,a5,0x1
 490:	9fb5                	addw	a5,a5,a3
 492:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 496:	00074683          	lbu	a3,0(a4)
 49a:	fd06879b          	addiw	a5,a3,-48
 49e:	0ff7f793          	zext.b	a5,a5
 4a2:	fef671e3          	bgeu	a2,a5,484 <atoi+0x1c>
  return n;
}
 4a6:	6422                	ld	s0,8(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret
  n = 0;
 4ac:	4501                	li	a0,0
 4ae:	bfe5                	j	4a6 <atoi+0x3e>

00000000000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4b6:	02b57463          	bgeu	a0,a1,4de <memmove+0x2e>
    while(n-- > 0)
 4ba:	00c05f63          	blez	a2,4d8 <memmove+0x28>
 4be:	1602                	slli	a2,a2,0x20
 4c0:	9201                	srli	a2,a2,0x20
 4c2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4c6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4c8:	0585                	addi	a1,a1,1
 4ca:	0705                	addi	a4,a4,1
 4cc:	fff5c683          	lbu	a3,-1(a1)
 4d0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4d4:	fef71ae3          	bne	a4,a5,4c8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4d8:	6422                	ld	s0,8(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret
    dst += n;
 4de:	00c50733          	add	a4,a0,a2
    src += n;
 4e2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4e4:	fec05ae3          	blez	a2,4d8 <memmove+0x28>
 4e8:	fff6079b          	addiw	a5,a2,-1
 4ec:	1782                	slli	a5,a5,0x20
 4ee:	9381                	srli	a5,a5,0x20
 4f0:	fff7c793          	not	a5,a5
 4f4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4f6:	15fd                	addi	a1,a1,-1
 4f8:	177d                	addi	a4,a4,-1
 4fa:	0005c683          	lbu	a3,0(a1)
 4fe:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 502:	fee79ae3          	bne	a5,a4,4f6 <memmove+0x46>
 506:	bfc9                	j	4d8 <memmove+0x28>

0000000000000508 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 508:	1141                	addi	sp,sp,-16
 50a:	e422                	sd	s0,8(sp)
 50c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 50e:	ca05                	beqz	a2,53e <memcmp+0x36>
 510:	fff6069b          	addiw	a3,a2,-1
 514:	1682                	slli	a3,a3,0x20
 516:	9281                	srli	a3,a3,0x20
 518:	0685                	addi	a3,a3,1
 51a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 51c:	00054783          	lbu	a5,0(a0)
 520:	0005c703          	lbu	a4,0(a1)
 524:	00e79863          	bne	a5,a4,534 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 528:	0505                	addi	a0,a0,1
    p2++;
 52a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 52c:	fed518e3          	bne	a0,a3,51c <memcmp+0x14>
  }
  return 0;
 530:	4501                	li	a0,0
 532:	a019                	j	538 <memcmp+0x30>
      return *p1 - *p2;
 534:	40e7853b          	subw	a0,a5,a4
}
 538:	6422                	ld	s0,8(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret
  return 0;
 53e:	4501                	li	a0,0
 540:	bfe5                	j	538 <memcmp+0x30>

0000000000000542 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 542:	1141                	addi	sp,sp,-16
 544:	e406                	sd	ra,8(sp)
 546:	e022                	sd	s0,0(sp)
 548:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 54a:	00000097          	auipc	ra,0x0
 54e:	f66080e7          	jalr	-154(ra) # 4b0 <memmove>
}
 552:	60a2                	ld	ra,8(sp)
 554:	6402                	ld	s0,0(sp)
 556:	0141                	addi	sp,sp,16
 558:	8082                	ret

000000000000055a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 55a:	4885                	li	a7,1
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <exit>:
.global exit
exit:
 li a7, SYS_exit
 562:	4889                	li	a7,2
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <wait>:
.global wait
wait:
 li a7, SYS_wait
 56a:	488d                	li	a7,3
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 572:	4891                	li	a7,4
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <read>:
.global read
read:
 li a7, SYS_read
 57a:	4895                	li	a7,5
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <write>:
.global write
write:
 li a7, SYS_write
 582:	48c1                	li	a7,16
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <close>:
.global close
close:
 li a7, SYS_close
 58a:	48d5                	li	a7,21
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <kill>:
.global kill
kill:
 li a7, SYS_kill
 592:	4899                	li	a7,6
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <exec>:
.global exec
exec:
 li a7, SYS_exec
 59a:	489d                	li	a7,7
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <open>:
.global open
open:
 li a7, SYS_open
 5a2:	48bd                	li	a7,15
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5aa:	48c5                	li	a7,17
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5b2:	48c9                	li	a7,18
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ba:	48a1                	li	a7,8
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <link>:
.global link
link:
 li a7, SYS_link
 5c2:	48cd                	li	a7,19
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ca:	48d1                	li	a7,20
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5d2:	48a5                	li	a7,9
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <dup>:
.global dup
dup:
 li a7, SYS_dup
 5da:	48a9                	li	a7,10
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5e2:	48ad                	li	a7,11
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ea:	48b1                	li	a7,12
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5f2:	48b5                	li	a7,13
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5fa:	48b9                	li	a7,14
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <yield>:
.global yield
yield:
 li a7, SYS_yield
 602:	48d9                	li	a7,22
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <lock>:
.global lock
lock:
 li a7, SYS_lock
 60a:	48dd                	li	a7,23
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 612:	48e1                	li	a7,24
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 61a:	1101                	addi	sp,sp,-32
 61c:	ec06                	sd	ra,24(sp)
 61e:	e822                	sd	s0,16(sp)
 620:	1000                	addi	s0,sp,32
 622:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 626:	4605                	li	a2,1
 628:	fef40593          	addi	a1,s0,-17
 62c:	00000097          	auipc	ra,0x0
 630:	f56080e7          	jalr	-170(ra) # 582 <write>
}
 634:	60e2                	ld	ra,24(sp)
 636:	6442                	ld	s0,16(sp)
 638:	6105                	addi	sp,sp,32
 63a:	8082                	ret

000000000000063c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 63c:	7139                	addi	sp,sp,-64
 63e:	fc06                	sd	ra,56(sp)
 640:	f822                	sd	s0,48(sp)
 642:	f426                	sd	s1,40(sp)
 644:	0080                	addi	s0,sp,64
 646:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 648:	c299                	beqz	a3,64e <printint+0x12>
 64a:	0805cb63          	bltz	a1,6e0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 64e:	2581                	sext.w	a1,a1
  neg = 0;
 650:	4881                	li	a7,0
 652:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 656:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 658:	2601                	sext.w	a2,a2
 65a:	00000517          	auipc	a0,0x0
 65e:	68650513          	addi	a0,a0,1670 # ce0 <digits>
 662:	883a                	mv	a6,a4
 664:	2705                	addiw	a4,a4,1
 666:	02c5f7bb          	remuw	a5,a1,a2
 66a:	1782                	slli	a5,a5,0x20
 66c:	9381                	srli	a5,a5,0x20
 66e:	97aa                	add	a5,a5,a0
 670:	0007c783          	lbu	a5,0(a5)
 674:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 678:	0005879b          	sext.w	a5,a1
 67c:	02c5d5bb          	divuw	a1,a1,a2
 680:	0685                	addi	a3,a3,1
 682:	fec7f0e3          	bgeu	a5,a2,662 <printint+0x26>
  if(neg)
 686:	00088c63          	beqz	a7,69e <printint+0x62>
    buf[i++] = '-';
 68a:	fd070793          	addi	a5,a4,-48
 68e:	00878733          	add	a4,a5,s0
 692:	02d00793          	li	a5,45
 696:	fef70823          	sb	a5,-16(a4)
 69a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 69e:	02e05c63          	blez	a4,6d6 <printint+0x9a>
 6a2:	f04a                	sd	s2,32(sp)
 6a4:	ec4e                	sd	s3,24(sp)
 6a6:	fc040793          	addi	a5,s0,-64
 6aa:	00e78933          	add	s2,a5,a4
 6ae:	fff78993          	addi	s3,a5,-1
 6b2:	99ba                	add	s3,s3,a4
 6b4:	377d                	addiw	a4,a4,-1
 6b6:	1702                	slli	a4,a4,0x20
 6b8:	9301                	srli	a4,a4,0x20
 6ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6be:	fff94583          	lbu	a1,-1(s2)
 6c2:	8526                	mv	a0,s1
 6c4:	00000097          	auipc	ra,0x0
 6c8:	f56080e7          	jalr	-170(ra) # 61a <putc>
  while(--i >= 0)
 6cc:	197d                	addi	s2,s2,-1
 6ce:	ff3918e3          	bne	s2,s3,6be <printint+0x82>
 6d2:	7902                	ld	s2,32(sp)
 6d4:	69e2                	ld	s3,24(sp)
}
 6d6:	70e2                	ld	ra,56(sp)
 6d8:	7442                	ld	s0,48(sp)
 6da:	74a2                	ld	s1,40(sp)
 6dc:	6121                	addi	sp,sp,64
 6de:	8082                	ret
    x = -xx;
 6e0:	40b005bb          	negw	a1,a1
    neg = 1;
 6e4:	4885                	li	a7,1
    x = -xx;
 6e6:	b7b5                	j	652 <printint+0x16>

00000000000006e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e8:	715d                	addi	sp,sp,-80
 6ea:	e486                	sd	ra,72(sp)
 6ec:	e0a2                	sd	s0,64(sp)
 6ee:	f84a                	sd	s2,48(sp)
 6f0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f2:	0005c903          	lbu	s2,0(a1)
 6f6:	1a090a63          	beqz	s2,8aa <vprintf+0x1c2>
 6fa:	fc26                	sd	s1,56(sp)
 6fc:	f44e                	sd	s3,40(sp)
 6fe:	f052                	sd	s4,32(sp)
 700:	ec56                	sd	s5,24(sp)
 702:	e85a                	sd	s6,16(sp)
 704:	e45e                	sd	s7,8(sp)
 706:	8aaa                	mv	s5,a0
 708:	8bb2                	mv	s7,a2
 70a:	00158493          	addi	s1,a1,1
  state = 0;
 70e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 710:	02500a13          	li	s4,37
 714:	4b55                	li	s6,21
 716:	a839                	j	734 <vprintf+0x4c>
        putc(fd, c);
 718:	85ca                	mv	a1,s2
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	efe080e7          	jalr	-258(ra) # 61a <putc>
 724:	a019                	j	72a <vprintf+0x42>
    } else if(state == '%'){
 726:	01498d63          	beq	s3,s4,740 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 72a:	0485                	addi	s1,s1,1
 72c:	fff4c903          	lbu	s2,-1(s1)
 730:	16090763          	beqz	s2,89e <vprintf+0x1b6>
    if(state == 0){
 734:	fe0999e3          	bnez	s3,726 <vprintf+0x3e>
      if(c == '%'){
 738:	ff4910e3          	bne	s2,s4,718 <vprintf+0x30>
        state = '%';
 73c:	89d2                	mv	s3,s4
 73e:	b7f5                	j	72a <vprintf+0x42>
      if(c == 'd'){
 740:	13490463          	beq	s2,s4,868 <vprintf+0x180>
 744:	f9d9079b          	addiw	a5,s2,-99
 748:	0ff7f793          	zext.b	a5,a5
 74c:	12fb6763          	bltu	s6,a5,87a <vprintf+0x192>
 750:	f9d9079b          	addiw	a5,s2,-99
 754:	0ff7f713          	zext.b	a4,a5
 758:	12eb6163          	bltu	s6,a4,87a <vprintf+0x192>
 75c:	00271793          	slli	a5,a4,0x2
 760:	00000717          	auipc	a4,0x0
 764:	52870713          	addi	a4,a4,1320 # c88 <malloc+0x1b8>
 768:	97ba                	add	a5,a5,a4
 76a:	439c                	lw	a5,0(a5)
 76c:	97ba                	add	a5,a5,a4
 76e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 770:	008b8913          	addi	s2,s7,8
 774:	4685                	li	a3,1
 776:	4629                	li	a2,10
 778:	000ba583          	lw	a1,0(s7)
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	ebe080e7          	jalr	-322(ra) # 63c <printint>
 786:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 788:	4981                	li	s3,0
 78a:	b745                	j	72a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78c:	008b8913          	addi	s2,s7,8
 790:	4681                	li	a3,0
 792:	4629                	li	a2,10
 794:	000ba583          	lw	a1,0(s7)
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	ea2080e7          	jalr	-350(ra) # 63c <printint>
 7a2:	8bca                	mv	s7,s2
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b751                	j	72a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7a8:	008b8913          	addi	s2,s7,8
 7ac:	4681                	li	a3,0
 7ae:	4641                	li	a2,16
 7b0:	000ba583          	lw	a1,0(s7)
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	e86080e7          	jalr	-378(ra) # 63c <printint>
 7be:	8bca                	mv	s7,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b7a5                	j	72a <vprintf+0x42>
 7c4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7c6:	008b8c13          	addi	s8,s7,8
 7ca:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ce:	03000593          	li	a1,48
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	e46080e7          	jalr	-442(ra) # 61a <putc>
  putc(fd, 'x');
 7dc:	07800593          	li	a1,120
 7e0:	8556                	mv	a0,s5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	e38080e7          	jalr	-456(ra) # 61a <putc>
 7ea:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ec:	00000b97          	auipc	s7,0x0
 7f0:	4f4b8b93          	addi	s7,s7,1268 # ce0 <digits>
 7f4:	03c9d793          	srli	a5,s3,0x3c
 7f8:	97de                	add	a5,a5,s7
 7fa:	0007c583          	lbu	a1,0(a5)
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	e1a080e7          	jalr	-486(ra) # 61a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 808:	0992                	slli	s3,s3,0x4
 80a:	397d                	addiw	s2,s2,-1
 80c:	fe0914e3          	bnez	s2,7f4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 810:	8be2                	mv	s7,s8
      state = 0;
 812:	4981                	li	s3,0
 814:	6c02                	ld	s8,0(sp)
 816:	bf11                	j	72a <vprintf+0x42>
        s = va_arg(ap, char*);
 818:	008b8993          	addi	s3,s7,8
 81c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 820:	02090163          	beqz	s2,842 <vprintf+0x15a>
        while(*s != 0){
 824:	00094583          	lbu	a1,0(s2)
 828:	c9a5                	beqz	a1,898 <vprintf+0x1b0>
          putc(fd, *s);
 82a:	8556                	mv	a0,s5
 82c:	00000097          	auipc	ra,0x0
 830:	dee080e7          	jalr	-530(ra) # 61a <putc>
          s++;
 834:	0905                	addi	s2,s2,1
        while(*s != 0){
 836:	00094583          	lbu	a1,0(s2)
 83a:	f9e5                	bnez	a1,82a <vprintf+0x142>
        s = va_arg(ap, char*);
 83c:	8bce                	mv	s7,s3
      state = 0;
 83e:	4981                	li	s3,0
 840:	b5ed                	j	72a <vprintf+0x42>
          s = "(null)";
 842:	00000917          	auipc	s2,0x0
 846:	43e90913          	addi	s2,s2,1086 # c80 <malloc+0x1b0>
        while(*s != 0){
 84a:	02800593          	li	a1,40
 84e:	bff1                	j	82a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 850:	008b8913          	addi	s2,s7,8
 854:	000bc583          	lbu	a1,0(s7)
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	dc0080e7          	jalr	-576(ra) # 61a <putc>
 862:	8bca                	mv	s7,s2
      state = 0;
 864:	4981                	li	s3,0
 866:	b5d1                	j	72a <vprintf+0x42>
        putc(fd, c);
 868:	02500593          	li	a1,37
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	dac080e7          	jalr	-596(ra) # 61a <putc>
      state = 0;
 876:	4981                	li	s3,0
 878:	bd4d                	j	72a <vprintf+0x42>
        putc(fd, '%');
 87a:	02500593          	li	a1,37
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	d9a080e7          	jalr	-614(ra) # 61a <putc>
        putc(fd, c);
 888:	85ca                	mv	a1,s2
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	d8e080e7          	jalr	-626(ra) # 61a <putc>
      state = 0;
 894:	4981                	li	s3,0
 896:	bd51                	j	72a <vprintf+0x42>
        s = va_arg(ap, char*);
 898:	8bce                	mv	s7,s3
      state = 0;
 89a:	4981                	li	s3,0
 89c:	b579                	j	72a <vprintf+0x42>
 89e:	74e2                	ld	s1,56(sp)
 8a0:	79a2                	ld	s3,40(sp)
 8a2:	7a02                	ld	s4,32(sp)
 8a4:	6ae2                	ld	s5,24(sp)
 8a6:	6b42                	ld	s6,16(sp)
 8a8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8aa:	60a6                	ld	ra,72(sp)
 8ac:	6406                	ld	s0,64(sp)
 8ae:	7942                	ld	s2,48(sp)
 8b0:	6161                	addi	sp,sp,80
 8b2:	8082                	ret

00000000000008b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b4:	715d                	addi	sp,sp,-80
 8b6:	ec06                	sd	ra,24(sp)
 8b8:	e822                	sd	s0,16(sp)
 8ba:	1000                	addi	s0,sp,32
 8bc:	e010                	sd	a2,0(s0)
 8be:	e414                	sd	a3,8(s0)
 8c0:	e818                	sd	a4,16(s0)
 8c2:	ec1c                	sd	a5,24(s0)
 8c4:	03043023          	sd	a6,32(s0)
 8c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d0:	8622                	mv	a2,s0
 8d2:	00000097          	auipc	ra,0x0
 8d6:	e16080e7          	jalr	-490(ra) # 6e8 <vprintf>
}
 8da:	60e2                	ld	ra,24(sp)
 8dc:	6442                	ld	s0,16(sp)
 8de:	6161                	addi	sp,sp,80
 8e0:	8082                	ret

00000000000008e2 <printf>:

void
printf(const char *fmt, ...)
{
 8e2:	7159                	addi	sp,sp,-112
 8e4:	f406                	sd	ra,40(sp)
 8e6:	f022                	sd	s0,32(sp)
 8e8:	ec26                	sd	s1,24(sp)
 8ea:	1800                	addi	s0,sp,48
 8ec:	84aa                	mv	s1,a0
 8ee:	e40c                	sd	a1,8(s0)
 8f0:	e810                	sd	a2,16(s0)
 8f2:	ec14                	sd	a3,24(s0)
 8f4:	f018                	sd	a4,32(s0)
 8f6:	f41c                	sd	a5,40(s0)
 8f8:	03043823          	sd	a6,48(s0)
 8fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 900:	00000097          	auipc	ra,0x0
 904:	d0a080e7          	jalr	-758(ra) # 60a <lock>
  va_start(ap, fmt);
 908:	00840613          	addi	a2,s0,8
 90c:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 910:	85a6                	mv	a1,s1
 912:	4505                	li	a0,1
 914:	00000097          	auipc	ra,0x0
 918:	dd4080e7          	jalr	-556(ra) # 6e8 <vprintf>
  unlock();
 91c:	00000097          	auipc	ra,0x0
 920:	cf6080e7          	jalr	-778(ra) # 612 <unlock>
}
 924:	70a2                	ld	ra,40(sp)
 926:	7402                	ld	s0,32(sp)
 928:	64e2                	ld	s1,24(sp)
 92a:	6165                	addi	sp,sp,112
 92c:	8082                	ret

000000000000092e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 92e:	7179                	addi	sp,sp,-48
 930:	f422                	sd	s0,40(sp)
 932:	1800                	addi	s0,sp,48
 934:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 938:	fd843783          	ld	a5,-40(s0)
 93c:	17c1                	addi	a5,a5,-16
 93e:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 942:	00001797          	auipc	a5,0x1
 946:	b1e78793          	addi	a5,a5,-1250 # 1460 <freep>
 94a:	639c                	ld	a5,0(a5)
 94c:	fef43423          	sd	a5,-24(s0)
 950:	a815                	j	984 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	fe843783          	ld	a5,-24(s0)
 956:	639c                	ld	a5,0(a5)
 958:	fe843703          	ld	a4,-24(s0)
 95c:	00f76f63          	bltu	a4,a5,97a <free+0x4c>
 960:	fe043703          	ld	a4,-32(s0)
 964:	fe843783          	ld	a5,-24(s0)
 968:	02e7eb63          	bltu	a5,a4,99e <free+0x70>
 96c:	fe843783          	ld	a5,-24(s0)
 970:	639c                	ld	a5,0(a5)
 972:	fe043703          	ld	a4,-32(s0)
 976:	02f76463          	bltu	a4,a5,99e <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97a:	fe843783          	ld	a5,-24(s0)
 97e:	639c                	ld	a5,0(a5)
 980:	fef43423          	sd	a5,-24(s0)
 984:	fe043703          	ld	a4,-32(s0)
 988:	fe843783          	ld	a5,-24(s0)
 98c:	fce7f3e3          	bgeu	a5,a4,952 <free+0x24>
 990:	fe843783          	ld	a5,-24(s0)
 994:	639c                	ld	a5,0(a5)
 996:	fe043703          	ld	a4,-32(s0)
 99a:	faf77ce3          	bgeu	a4,a5,952 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 99e:	fe043783          	ld	a5,-32(s0)
 9a2:	479c                	lw	a5,8(a5)
 9a4:	1782                	slli	a5,a5,0x20
 9a6:	9381                	srli	a5,a5,0x20
 9a8:	0792                	slli	a5,a5,0x4
 9aa:	fe043703          	ld	a4,-32(s0)
 9ae:	973e                	add	a4,a4,a5
 9b0:	fe843783          	ld	a5,-24(s0)
 9b4:	639c                	ld	a5,0(a5)
 9b6:	02f71763          	bne	a4,a5,9e4 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 9ba:	fe043783          	ld	a5,-32(s0)
 9be:	4798                	lw	a4,8(a5)
 9c0:	fe843783          	ld	a5,-24(s0)
 9c4:	639c                	ld	a5,0(a5)
 9c6:	479c                	lw	a5,8(a5)
 9c8:	9fb9                	addw	a5,a5,a4
 9ca:	0007871b          	sext.w	a4,a5
 9ce:	fe043783          	ld	a5,-32(s0)
 9d2:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 9d4:	fe843783          	ld	a5,-24(s0)
 9d8:	639c                	ld	a5,0(a5)
 9da:	6398                	ld	a4,0(a5)
 9dc:	fe043783          	ld	a5,-32(s0)
 9e0:	e398                	sd	a4,0(a5)
 9e2:	a039                	j	9f0 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 9e4:	fe843783          	ld	a5,-24(s0)
 9e8:	6398                	ld	a4,0(a5)
 9ea:	fe043783          	ld	a5,-32(s0)
 9ee:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 9f0:	fe843783          	ld	a5,-24(s0)
 9f4:	479c                	lw	a5,8(a5)
 9f6:	1782                	slli	a5,a5,0x20
 9f8:	9381                	srli	a5,a5,0x20
 9fa:	0792                	slli	a5,a5,0x4
 9fc:	fe843703          	ld	a4,-24(s0)
 a00:	97ba                	add	a5,a5,a4
 a02:	fe043703          	ld	a4,-32(s0)
 a06:	02f71563          	bne	a4,a5,a30 <free+0x102>
    p->s.size += bp->s.size;
 a0a:	fe843783          	ld	a5,-24(s0)
 a0e:	4798                	lw	a4,8(a5)
 a10:	fe043783          	ld	a5,-32(s0)
 a14:	479c                	lw	a5,8(a5)
 a16:	9fb9                	addw	a5,a5,a4
 a18:	0007871b          	sext.w	a4,a5
 a1c:	fe843783          	ld	a5,-24(s0)
 a20:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a22:	fe043783          	ld	a5,-32(s0)
 a26:	6398                	ld	a4,0(a5)
 a28:	fe843783          	ld	a5,-24(s0)
 a2c:	e398                	sd	a4,0(a5)
 a2e:	a031                	j	a3a <free+0x10c>
  } else
    p->s.ptr = bp;
 a30:	fe843783          	ld	a5,-24(s0)
 a34:	fe043703          	ld	a4,-32(s0)
 a38:	e398                	sd	a4,0(a5)
  freep = p;
 a3a:	00001797          	auipc	a5,0x1
 a3e:	a2678793          	addi	a5,a5,-1498 # 1460 <freep>
 a42:	fe843703          	ld	a4,-24(s0)
 a46:	e398                	sd	a4,0(a5)
}
 a48:	0001                	nop
 a4a:	7422                	ld	s0,40(sp)
 a4c:	6145                	addi	sp,sp,48
 a4e:	8082                	ret

0000000000000a50 <morecore>:

static Header*
morecore(uint nu)
{
 a50:	7179                	addi	sp,sp,-48
 a52:	f406                	sd	ra,40(sp)
 a54:	f022                	sd	s0,32(sp)
 a56:	1800                	addi	s0,sp,48
 a58:	87aa                	mv	a5,a0
 a5a:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 a5e:	fdc42783          	lw	a5,-36(s0)
 a62:	0007871b          	sext.w	a4,a5
 a66:	6785                	lui	a5,0x1
 a68:	00f77563          	bgeu	a4,a5,a72 <morecore+0x22>
    nu = 4096;
 a6c:	6785                	lui	a5,0x1
 a6e:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 a72:	fdc42783          	lw	a5,-36(s0)
 a76:	0047979b          	slliw	a5,a5,0x4
 a7a:	2781                	sext.w	a5,a5
 a7c:	2781                	sext.w	a5,a5
 a7e:	853e                	mv	a0,a5
 a80:	00000097          	auipc	ra,0x0
 a84:	b6a080e7          	jalr	-1174(ra) # 5ea <sbrk>
 a88:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 a8c:	fe843703          	ld	a4,-24(s0)
 a90:	57fd                	li	a5,-1
 a92:	00f71463          	bne	a4,a5,a9a <morecore+0x4a>
    return 0;
 a96:	4781                	li	a5,0
 a98:	a03d                	j	ac6 <morecore+0x76>
  hp = (Header*)p;
 a9a:	fe843783          	ld	a5,-24(s0)
 a9e:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 aa2:	fe043783          	ld	a5,-32(s0)
 aa6:	fdc42703          	lw	a4,-36(s0)
 aaa:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 aac:	fe043783          	ld	a5,-32(s0)
 ab0:	07c1                	addi	a5,a5,16 # 1010 <digits+0x330>
 ab2:	853e                	mv	a0,a5
 ab4:	00000097          	auipc	ra,0x0
 ab8:	e7a080e7          	jalr	-390(ra) # 92e <free>
  return freep;
 abc:	00001797          	auipc	a5,0x1
 ac0:	9a478793          	addi	a5,a5,-1628 # 1460 <freep>
 ac4:	639c                	ld	a5,0(a5)
}
 ac6:	853e                	mv	a0,a5
 ac8:	70a2                	ld	ra,40(sp)
 aca:	7402                	ld	s0,32(sp)
 acc:	6145                	addi	sp,sp,48
 ace:	8082                	ret

0000000000000ad0 <malloc>:

void*
malloc(uint nbytes)
{
 ad0:	7139                	addi	sp,sp,-64
 ad2:	fc06                	sd	ra,56(sp)
 ad4:	f822                	sd	s0,48(sp)
 ad6:	0080                	addi	s0,sp,64
 ad8:	87aa                	mv	a5,a0
 ada:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ade:	fcc46783          	lwu	a5,-52(s0)
 ae2:	07bd                	addi	a5,a5,15
 ae4:	8391                	srli	a5,a5,0x4
 ae6:	2781                	sext.w	a5,a5
 ae8:	2785                	addiw	a5,a5,1
 aea:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 aee:	00001797          	auipc	a5,0x1
 af2:	97278793          	addi	a5,a5,-1678 # 1460 <freep>
 af6:	639c                	ld	a5,0(a5)
 af8:	fef43023          	sd	a5,-32(s0)
 afc:	fe043783          	ld	a5,-32(s0)
 b00:	ef95                	bnez	a5,b3c <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 b02:	00001797          	auipc	a5,0x1
 b06:	94e78793          	addi	a5,a5,-1714 # 1450 <base>
 b0a:	fef43023          	sd	a5,-32(s0)
 b0e:	00001797          	auipc	a5,0x1
 b12:	95278793          	addi	a5,a5,-1710 # 1460 <freep>
 b16:	fe043703          	ld	a4,-32(s0)
 b1a:	e398                	sd	a4,0(a5)
 b1c:	00001797          	auipc	a5,0x1
 b20:	94478793          	addi	a5,a5,-1724 # 1460 <freep>
 b24:	6398                	ld	a4,0(a5)
 b26:	00001797          	auipc	a5,0x1
 b2a:	92a78793          	addi	a5,a5,-1750 # 1450 <base>
 b2e:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 b30:	00001797          	auipc	a5,0x1
 b34:	92078793          	addi	a5,a5,-1760 # 1450 <base>
 b38:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3c:	fe043783          	ld	a5,-32(s0)
 b40:	639c                	ld	a5,0(a5)
 b42:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 b46:	fe843783          	ld	a5,-24(s0)
 b4a:	4798                	lw	a4,8(a5)
 b4c:	fdc42783          	lw	a5,-36(s0)
 b50:	2781                	sext.w	a5,a5
 b52:	06f76763          	bltu	a4,a5,bc0 <malloc+0xf0>
      if(p->s.size == nunits)
 b56:	fe843783          	ld	a5,-24(s0)
 b5a:	4798                	lw	a4,8(a5)
 b5c:	fdc42783          	lw	a5,-36(s0)
 b60:	2781                	sext.w	a5,a5
 b62:	00e79963          	bne	a5,a4,b74 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 b66:	fe843783          	ld	a5,-24(s0)
 b6a:	6398                	ld	a4,0(a5)
 b6c:	fe043783          	ld	a5,-32(s0)
 b70:	e398                	sd	a4,0(a5)
 b72:	a825                	j	baa <malloc+0xda>
      else {
        p->s.size -= nunits;
 b74:	fe843783          	ld	a5,-24(s0)
 b78:	479c                	lw	a5,8(a5)
 b7a:	fdc42703          	lw	a4,-36(s0)
 b7e:	9f99                	subw	a5,a5,a4
 b80:	0007871b          	sext.w	a4,a5
 b84:	fe843783          	ld	a5,-24(s0)
 b88:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b8a:	fe843783          	ld	a5,-24(s0)
 b8e:	479c                	lw	a5,8(a5)
 b90:	1782                	slli	a5,a5,0x20
 b92:	9381                	srli	a5,a5,0x20
 b94:	0792                	slli	a5,a5,0x4
 b96:	fe843703          	ld	a4,-24(s0)
 b9a:	97ba                	add	a5,a5,a4
 b9c:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 ba0:	fe843783          	ld	a5,-24(s0)
 ba4:	fdc42703          	lw	a4,-36(s0)
 ba8:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 baa:	00001797          	auipc	a5,0x1
 bae:	8b678793          	addi	a5,a5,-1866 # 1460 <freep>
 bb2:	fe043703          	ld	a4,-32(s0)
 bb6:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 bb8:	fe843783          	ld	a5,-24(s0)
 bbc:	07c1                	addi	a5,a5,16
 bbe:	a091                	j	c02 <malloc+0x132>
    }
    if(p == freep)
 bc0:	00001797          	auipc	a5,0x1
 bc4:	8a078793          	addi	a5,a5,-1888 # 1460 <freep>
 bc8:	639c                	ld	a5,0(a5)
 bca:	fe843703          	ld	a4,-24(s0)
 bce:	02f71063          	bne	a4,a5,bee <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 bd2:	fdc42783          	lw	a5,-36(s0)
 bd6:	853e                	mv	a0,a5
 bd8:	00000097          	auipc	ra,0x0
 bdc:	e78080e7          	jalr	-392(ra) # a50 <morecore>
 be0:	fea43423          	sd	a0,-24(s0)
 be4:	fe843783          	ld	a5,-24(s0)
 be8:	e399                	bnez	a5,bee <malloc+0x11e>
        return 0;
 bea:	4781                	li	a5,0
 bec:	a819                	j	c02 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bee:	fe843783          	ld	a5,-24(s0)
 bf2:	fef43023          	sd	a5,-32(s0)
 bf6:	fe843783          	ld	a5,-24(s0)
 bfa:	639c                	ld	a5,0(a5)
 bfc:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 c00:	b799                	j	b46 <malloc+0x76>
  }
}
 c02:	853e                	mv	a0,a5
 c04:	70e2                	ld	ra,56(sp)
 c06:	7442                	ld	s0,48(sp)
 c08:	6121                	addi	sp,sp,64
 c0a:	8082                	ret
