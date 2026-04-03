
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	4fe58593          	addi	a1,a1,1278 # 1510 <malloc+0x13c>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	e6a080e7          	jalr	-406(ra) # e86 <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	c42080e7          	jalr	-958(ra) # c6c <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	c7c080e7          	jalr	-900(ra) # cb2 <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
  exit(0);
}

void
panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	4c058593          	addi	a1,a1,1216 # 1520 <malloc+0x14c>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	14e080e7          	jalr	334(ra) # 11b8 <fprintf>
  exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	df2080e7          	jalr	-526(ra) # e66 <exit>

000000000000007c <fork1>:
}

int
fork1(void)
{
      7c:	1141                	addi	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	dda080e7          	jalr	-550(ra) # e5e <fork>
  if(pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
    panic("fork");
  return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	addi	sp,sp,16
      98:	8082                	ret
    panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	48e50513          	addi	a0,a0,1166 # 1528 <malloc+0x154>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7139                	addi	sp,sp,-64
      ac:	fc06                	sd	ra,56(sp)
      ae:	f822                	sd	s0,48(sp)
      b0:	0080                	addi	s0,sp,64
  if(cmd == 0)
      b2:	c505                	beqz	a0,da <runcmd+0x30>
      b4:	f426                	sd	s1,40(sp)
      b6:	f04a                	sd	s2,32(sp)
      b8:	ec4e                	sd	s3,24(sp)
      ba:	84aa                	mv	s1,a0
  switch(cmd->type){
      bc:	4118                	lw	a4,0(a0)
      be:	4795                	li	a5,5
      c0:	02e7e563          	bltu	a5,a4,ea <runcmd+0x40>
      c4:	00056783          	lwu	a5,0(a0)
      c8:	078a                	slli	a5,a5,0x2
      ca:	00001717          	auipc	a4,0x1
      ce:	56670713          	addi	a4,a4,1382 # 1630 <malloc+0x25c>
      d2:	97ba                	add	a5,a5,a4
      d4:	439c                	lw	a5,0(a5)
      d6:	97ba                	add	a5,a5,a4
      d8:	8782                	jr	a5
      da:	f426                	sd	s1,40(sp)
      dc:	f04a                	sd	s2,32(sp)
      de:	ec4e                	sd	s3,24(sp)
    exit(1);
      e0:	4505                	li	a0,1
      e2:	00001097          	auipc	ra,0x1
      e6:	d84080e7          	jalr	-636(ra) # e66 <exit>
    panic("runcmd");
      ea:	00001517          	auipc	a0,0x1
      ee:	44650513          	addi	a0,a0,1094 # 1530 <malloc+0x15c>
      f2:	00000097          	auipc	ra,0x0
      f6:	f64080e7          	jalr	-156(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
      fa:	6508                	ld	a0,8(a0)
      fc:	c551                	beqz	a0,188 <runcmd+0xde>
    exec(ecmd->argv[0], ecmd->argv);
      fe:	00848993          	addi	s3,s1,8
     102:	85ce                	mv	a1,s3
     104:	00001097          	auipc	ra,0x1
     108:	d9a080e7          	jalr	-614(ra) # e9e <exec>
    tmp[0] = '/';
     10c:	00002917          	auipc	s2,0x2
     110:	6b490913          	addi	s2,s2,1716 # 27c0 <tmp.1>
     114:	02f00793          	li	a5,47
     118:	00f90023          	sb	a5,0(s2)
    strcpy(tmp+1, ecmd->argv[0]);
     11c:	648c                	ld	a1,8(s1)
     11e:	00002517          	auipc	a0,0x2
     122:	6a350513          	addi	a0,a0,1699 # 27c1 <tmp.1+0x1>
     126:	00001097          	auipc	ra,0x1
     12a:	ad4080e7          	jalr	-1324(ra) # bfa <strcpy>
    exec(tmp, ecmd->argv);
     12e:	85ce                	mv	a1,s3
     130:	854a                	mv	a0,s2
     132:	00001097          	auipc	ra,0x1
     136:	d6c080e7          	jalr	-660(ra) # e9e <exec>
    strcpy(tmp, "/tests/");
     13a:	00001597          	auipc	a1,0x1
     13e:	3fe58593          	addi	a1,a1,1022 # 1538 <malloc+0x164>
     142:	854a                	mv	a0,s2
     144:	00001097          	auipc	ra,0x1
     148:	ab6080e7          	jalr	-1354(ra) # bfa <strcpy>
    strcpy(tmp+7, ecmd->argv[0]);
     14c:	648c                	ld	a1,8(s1)
     14e:	00002517          	auipc	a0,0x2
     152:	67950513          	addi	a0,a0,1657 # 27c7 <tmp.1+0x7>
     156:	00001097          	auipc	ra,0x1
     15a:	aa4080e7          	jalr	-1372(ra) # bfa <strcpy>
    exec(tmp, ecmd->argv);
     15e:	85ce                	mv	a1,s3
     160:	854a                	mv	a0,s2
     162:	00001097          	auipc	ra,0x1
     166:	d3c080e7          	jalr	-708(ra) # e9e <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     16a:	6490                	ld	a2,8(s1)
     16c:	00001597          	auipc	a1,0x1
     170:	3d458593          	addi	a1,a1,980 # 1540 <malloc+0x16c>
     174:	4509                	li	a0,2
     176:	00001097          	auipc	ra,0x1
     17a:	042080e7          	jalr	66(ra) # 11b8 <fprintf>
  exit(0);
     17e:	4501                	li	a0,0
     180:	00001097          	auipc	ra,0x1
     184:	ce6080e7          	jalr	-794(ra) # e66 <exit>
      exit(1);
     188:	4505                	li	a0,1
     18a:	00001097          	auipc	ra,0x1
     18e:	cdc080e7          	jalr	-804(ra) # e66 <exit>
    close(rcmd->fd);
     192:	5148                	lw	a0,36(a0)
     194:	00001097          	auipc	ra,0x1
     198:	cfa080e7          	jalr	-774(ra) # e8e <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     19c:	508c                	lw	a1,32(s1)
     19e:	6888                	ld	a0,16(s1)
     1a0:	00001097          	auipc	ra,0x1
     1a4:	d06080e7          	jalr	-762(ra) # ea6 <open>
     1a8:	00054763          	bltz	a0,1b6 <runcmd+0x10c>
    runcmd(rcmd->cmd);
     1ac:	6488                	ld	a0,8(s1)
     1ae:	00000097          	auipc	ra,0x0
     1b2:	efc080e7          	jalr	-260(ra) # aa <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     1b6:	6890                	ld	a2,16(s1)
     1b8:	00001597          	auipc	a1,0x1
     1bc:	39858593          	addi	a1,a1,920 # 1550 <malloc+0x17c>
     1c0:	4509                	li	a0,2
     1c2:	00001097          	auipc	ra,0x1
     1c6:	ff6080e7          	jalr	-10(ra) # 11b8 <fprintf>
      exit(1);
     1ca:	4505                	li	a0,1
     1cc:	00001097          	auipc	ra,0x1
     1d0:	c9a080e7          	jalr	-870(ra) # e66 <exit>
    if(fork1() == 0)
     1d4:	00000097          	auipc	ra,0x0
     1d8:	ea8080e7          	jalr	-344(ra) # 7c <fork1>
     1dc:	e511                	bnez	a0,1e8 <runcmd+0x13e>
      runcmd(lcmd->left);
     1de:	6488                	ld	a0,8(s1)
     1e0:	00000097          	auipc	ra,0x0
     1e4:	eca080e7          	jalr	-310(ra) # aa <runcmd>
    wait(0);
     1e8:	4501                	li	a0,0
     1ea:	00001097          	auipc	ra,0x1
     1ee:	c84080e7          	jalr	-892(ra) # e6e <wait>
    runcmd(lcmd->right);
     1f2:	6888                	ld	a0,16(s1)
     1f4:	00000097          	auipc	ra,0x0
     1f8:	eb6080e7          	jalr	-330(ra) # aa <runcmd>
    if(pipe(p) < 0)
     1fc:	fc840513          	addi	a0,s0,-56
     200:	00001097          	auipc	ra,0x1
     204:	c76080e7          	jalr	-906(ra) # e76 <pipe>
     208:	04054363          	bltz	a0,24e <runcmd+0x1a4>
    if(fork1() == 0){
     20c:	00000097          	auipc	ra,0x0
     210:	e70080e7          	jalr	-400(ra) # 7c <fork1>
     214:	e529                	bnez	a0,25e <runcmd+0x1b4>
      close(1);
     216:	4505                	li	a0,1
     218:	00001097          	auipc	ra,0x1
     21c:	c76080e7          	jalr	-906(ra) # e8e <close>
      dup(p[1]);
     220:	fcc42503          	lw	a0,-52(s0)
     224:	00001097          	auipc	ra,0x1
     228:	cba080e7          	jalr	-838(ra) # ede <dup>
      close(p[0]);
     22c:	fc842503          	lw	a0,-56(s0)
     230:	00001097          	auipc	ra,0x1
     234:	c5e080e7          	jalr	-930(ra) # e8e <close>
      close(p[1]);
     238:	fcc42503          	lw	a0,-52(s0)
     23c:	00001097          	auipc	ra,0x1
     240:	c52080e7          	jalr	-942(ra) # e8e <close>
      runcmd(pcmd->left);
     244:	6488                	ld	a0,8(s1)
     246:	00000097          	auipc	ra,0x0
     24a:	e64080e7          	jalr	-412(ra) # aa <runcmd>
      panic("pipe");
     24e:	00001517          	auipc	a0,0x1
     252:	31250513          	addi	a0,a0,786 # 1560 <malloc+0x18c>
     256:	00000097          	auipc	ra,0x0
     25a:	e00080e7          	jalr	-512(ra) # 56 <panic>
    if(fork1() == 0){
     25e:	00000097          	auipc	ra,0x0
     262:	e1e080e7          	jalr	-482(ra) # 7c <fork1>
     266:	ed05                	bnez	a0,29e <runcmd+0x1f4>
      close(0);
     268:	00001097          	auipc	ra,0x1
     26c:	c26080e7          	jalr	-986(ra) # e8e <close>
      dup(p[0]);
     270:	fc842503          	lw	a0,-56(s0)
     274:	00001097          	auipc	ra,0x1
     278:	c6a080e7          	jalr	-918(ra) # ede <dup>
      close(p[0]);
     27c:	fc842503          	lw	a0,-56(s0)
     280:	00001097          	auipc	ra,0x1
     284:	c0e080e7          	jalr	-1010(ra) # e8e <close>
      close(p[1]);
     288:	fcc42503          	lw	a0,-52(s0)
     28c:	00001097          	auipc	ra,0x1
     290:	c02080e7          	jalr	-1022(ra) # e8e <close>
      runcmd(pcmd->right);
     294:	6888                	ld	a0,16(s1)
     296:	00000097          	auipc	ra,0x0
     29a:	e14080e7          	jalr	-492(ra) # aa <runcmd>
    close(p[0]);
     29e:	fc842503          	lw	a0,-56(s0)
     2a2:	00001097          	auipc	ra,0x1
     2a6:	bec080e7          	jalr	-1044(ra) # e8e <close>
    close(p[1]);
     2aa:	fcc42503          	lw	a0,-52(s0)
     2ae:	00001097          	auipc	ra,0x1
     2b2:	be0080e7          	jalr	-1056(ra) # e8e <close>
    wait(0);
     2b6:	4501                	li	a0,0
     2b8:	00001097          	auipc	ra,0x1
     2bc:	bb6080e7          	jalr	-1098(ra) # e6e <wait>
    wait(0);
     2c0:	4501                	li	a0,0
     2c2:	00001097          	auipc	ra,0x1
     2c6:	bac080e7          	jalr	-1108(ra) # e6e <wait>
    break;
     2ca:	bd55                	j	17e <runcmd+0xd4>
    if(fork1() == 0)
     2cc:	00000097          	auipc	ra,0x0
     2d0:	db0080e7          	jalr	-592(ra) # 7c <fork1>
     2d4:	ea0515e3          	bnez	a0,17e <runcmd+0xd4>
      runcmd(bcmd->cmd);
     2d8:	6488                	ld	a0,8(s1)
     2da:	00000097          	auipc	ra,0x0
     2de:	dd0080e7          	jalr	-560(ra) # aa <runcmd>

00000000000002e2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     2e2:	1101                	addi	sp,sp,-32
     2e4:	ec06                	sd	ra,24(sp)
     2e6:	e822                	sd	s0,16(sp)
     2e8:	e426                	sd	s1,8(sp)
     2ea:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ec:	0a800513          	li	a0,168
     2f0:	00001097          	auipc	ra,0x1
     2f4:	0e4080e7          	jalr	228(ra) # 13d4 <malloc>
     2f8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2fa:	0a800613          	li	a2,168
     2fe:	4581                	li	a1,0
     300:	00001097          	auipc	ra,0x1
     304:	96c080e7          	jalr	-1684(ra) # c6c <memset>
  cmd->type = EXEC;
     308:	4785                	li	a5,1
     30a:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     30c:	8526                	mv	a0,s1
     30e:	60e2                	ld	ra,24(sp)
     310:	6442                	ld	s0,16(sp)
     312:	64a2                	ld	s1,8(sp)
     314:	6105                	addi	sp,sp,32
     316:	8082                	ret

0000000000000318 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     318:	7139                	addi	sp,sp,-64
     31a:	fc06                	sd	ra,56(sp)
     31c:	f822                	sd	s0,48(sp)
     31e:	f426                	sd	s1,40(sp)
     320:	f04a                	sd	s2,32(sp)
     322:	ec4e                	sd	s3,24(sp)
     324:	e852                	sd	s4,16(sp)
     326:	e456                	sd	s5,8(sp)
     328:	e05a                	sd	s6,0(sp)
     32a:	0080                	addi	s0,sp,64
     32c:	8b2a                	mv	s6,a0
     32e:	8aae                	mv	s5,a1
     330:	8a32                	mv	s4,a2
     332:	89b6                	mv	s3,a3
     334:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     336:	02800513          	li	a0,40
     33a:	00001097          	auipc	ra,0x1
     33e:	09a080e7          	jalr	154(ra) # 13d4 <malloc>
     342:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     344:	02800613          	li	a2,40
     348:	4581                	li	a1,0
     34a:	00001097          	auipc	ra,0x1
     34e:	922080e7          	jalr	-1758(ra) # c6c <memset>
  cmd->type = REDIR;
     352:	4789                	li	a5,2
     354:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     356:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     35a:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     35e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     362:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     366:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     36a:	8526                	mv	a0,s1
     36c:	70e2                	ld	ra,56(sp)
     36e:	7442                	ld	s0,48(sp)
     370:	74a2                	ld	s1,40(sp)
     372:	7902                	ld	s2,32(sp)
     374:	69e2                	ld	s3,24(sp)
     376:	6a42                	ld	s4,16(sp)
     378:	6aa2                	ld	s5,8(sp)
     37a:	6b02                	ld	s6,0(sp)
     37c:	6121                	addi	sp,sp,64
     37e:	8082                	ret

0000000000000380 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     380:	7179                	addi	sp,sp,-48
     382:	f406                	sd	ra,40(sp)
     384:	f022                	sd	s0,32(sp)
     386:	ec26                	sd	s1,24(sp)
     388:	e84a                	sd	s2,16(sp)
     38a:	e44e                	sd	s3,8(sp)
     38c:	1800                	addi	s0,sp,48
     38e:	89aa                	mv	s3,a0
     390:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     392:	4561                	li	a0,24
     394:	00001097          	auipc	ra,0x1
     398:	040080e7          	jalr	64(ra) # 13d4 <malloc>
     39c:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     39e:	4661                	li	a2,24
     3a0:	4581                	li	a1,0
     3a2:	00001097          	auipc	ra,0x1
     3a6:	8ca080e7          	jalr	-1846(ra) # c6c <memset>
  cmd->type = PIPE;
     3aa:	478d                	li	a5,3
     3ac:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     3ae:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     3b2:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     3b6:	8526                	mv	a0,s1
     3b8:	70a2                	ld	ra,40(sp)
     3ba:	7402                	ld	s0,32(sp)
     3bc:	64e2                	ld	s1,24(sp)
     3be:	6942                	ld	s2,16(sp)
     3c0:	69a2                	ld	s3,8(sp)
     3c2:	6145                	addi	sp,sp,48
     3c4:	8082                	ret

00000000000003c6 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     3c6:	7179                	addi	sp,sp,-48
     3c8:	f406                	sd	ra,40(sp)
     3ca:	f022                	sd	s0,32(sp)
     3cc:	ec26                	sd	s1,24(sp)
     3ce:	e84a                	sd	s2,16(sp)
     3d0:	e44e                	sd	s3,8(sp)
     3d2:	1800                	addi	s0,sp,48
     3d4:	89aa                	mv	s3,a0
     3d6:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3d8:	4561                	li	a0,24
     3da:	00001097          	auipc	ra,0x1
     3de:	ffa080e7          	jalr	-6(ra) # 13d4 <malloc>
     3e2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3e4:	4661                	li	a2,24
     3e6:	4581                	li	a1,0
     3e8:	00001097          	auipc	ra,0x1
     3ec:	884080e7          	jalr	-1916(ra) # c6c <memset>
  cmd->type = LIST;
     3f0:	4791                	li	a5,4
     3f2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     3f4:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     3f8:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     3fc:	8526                	mv	a0,s1
     3fe:	70a2                	ld	ra,40(sp)
     400:	7402                	ld	s0,32(sp)
     402:	64e2                	ld	s1,24(sp)
     404:	6942                	ld	s2,16(sp)
     406:	69a2                	ld	s3,8(sp)
     408:	6145                	addi	sp,sp,48
     40a:	8082                	ret

000000000000040c <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     40c:	1101                	addi	sp,sp,-32
     40e:	ec06                	sd	ra,24(sp)
     410:	e822                	sd	s0,16(sp)
     412:	e426                	sd	s1,8(sp)
     414:	e04a                	sd	s2,0(sp)
     416:	1000                	addi	s0,sp,32
     418:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     41a:	4541                	li	a0,16
     41c:	00001097          	auipc	ra,0x1
     420:	fb8080e7          	jalr	-72(ra) # 13d4 <malloc>
     424:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     426:	4641                	li	a2,16
     428:	4581                	li	a1,0
     42a:	00001097          	auipc	ra,0x1
     42e:	842080e7          	jalr	-1982(ra) # c6c <memset>
  cmd->type = BACK;
     432:	4795                	li	a5,5
     434:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     436:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     43a:	8526                	mv	a0,s1
     43c:	60e2                	ld	ra,24(sp)
     43e:	6442                	ld	s0,16(sp)
     440:	64a2                	ld	s1,8(sp)
     442:	6902                	ld	s2,0(sp)
     444:	6105                	addi	sp,sp,32
     446:	8082                	ret

0000000000000448 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     448:	7139                	addi	sp,sp,-64
     44a:	fc06                	sd	ra,56(sp)
     44c:	f822                	sd	s0,48(sp)
     44e:	f426                	sd	s1,40(sp)
     450:	f04a                	sd	s2,32(sp)
     452:	ec4e                	sd	s3,24(sp)
     454:	e852                	sd	s4,16(sp)
     456:	e456                	sd	s5,8(sp)
     458:	e05a                	sd	s6,0(sp)
     45a:	0080                	addi	s0,sp,64
     45c:	8a2a                	mv	s4,a0
     45e:	892e                	mv	s2,a1
     460:	8ab2                	mv	s5,a2
     462:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     464:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     466:	00002997          	auipc	s3,0x2
     46a:	35298993          	addi	s3,s3,850 # 27b8 <whitespace>
     46e:	00b4fe63          	bgeu	s1,a1,48a <gettoken+0x42>
     472:	0004c583          	lbu	a1,0(s1)
     476:	854e                	mv	a0,s3
     478:	00001097          	auipc	ra,0x1
     47c:	816080e7          	jalr	-2026(ra) # c8e <strchr>
     480:	c509                	beqz	a0,48a <gettoken+0x42>
    s++;
     482:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     484:	fe9917e3          	bne	s2,s1,472 <gettoken+0x2a>
     488:	84ca                	mv	s1,s2
  if(q)
     48a:	000a8463          	beqz	s5,492 <gettoken+0x4a>
    *q = s;
     48e:	009ab023          	sd	s1,0(s5)
  ret = *s;
     492:	0004c783          	lbu	a5,0(s1)
     496:	00078a9b          	sext.w	s5,a5
  switch(*s){
     49a:	03c00713          	li	a4,60
     49e:	06f76663          	bltu	a4,a5,50a <gettoken+0xc2>
     4a2:	03a00713          	li	a4,58
     4a6:	00f76e63          	bltu	a4,a5,4c2 <gettoken+0x7a>
     4aa:	cf89                	beqz	a5,4c4 <gettoken+0x7c>
     4ac:	02600713          	li	a4,38
     4b0:	00e78963          	beq	a5,a4,4c2 <gettoken+0x7a>
     4b4:	fd87879b          	addiw	a5,a5,-40
     4b8:	0ff7f793          	zext.b	a5,a5
     4bc:	4705                	li	a4,1
     4be:	06f76d63          	bltu	a4,a5,538 <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     4c2:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     4c4:	000b0463          	beqz	s6,4cc <gettoken+0x84>
    *eq = s;
     4c8:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     4cc:	00002997          	auipc	s3,0x2
     4d0:	2ec98993          	addi	s3,s3,748 # 27b8 <whitespace>
     4d4:	0124fe63          	bgeu	s1,s2,4f0 <gettoken+0xa8>
     4d8:	0004c583          	lbu	a1,0(s1)
     4dc:	854e                	mv	a0,s3
     4de:	00000097          	auipc	ra,0x0
     4e2:	7b0080e7          	jalr	1968(ra) # c8e <strchr>
     4e6:	c509                	beqz	a0,4f0 <gettoken+0xa8>
    s++;
     4e8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     4ea:	fe9917e3          	bne	s2,s1,4d8 <gettoken+0x90>
     4ee:	84ca                	mv	s1,s2
  *ps = s;
     4f0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     4f4:	8556                	mv	a0,s5
     4f6:	70e2                	ld	ra,56(sp)
     4f8:	7442                	ld	s0,48(sp)
     4fa:	74a2                	ld	s1,40(sp)
     4fc:	7902                	ld	s2,32(sp)
     4fe:	69e2                	ld	s3,24(sp)
     500:	6a42                	ld	s4,16(sp)
     502:	6aa2                	ld	s5,8(sp)
     504:	6b02                	ld	s6,0(sp)
     506:	6121                	addi	sp,sp,64
     508:	8082                	ret
  switch(*s){
     50a:	03e00713          	li	a4,62
     50e:	02e79163          	bne	a5,a4,530 <gettoken+0xe8>
    s++;
     512:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     516:	0014c703          	lbu	a4,1(s1)
     51a:	03e00793          	li	a5,62
      s++;
     51e:	0489                	addi	s1,s1,2
      ret = '+';
     520:	02b00a93          	li	s5,43
    if(*s == '>'){
     524:	faf700e3          	beq	a4,a5,4c4 <gettoken+0x7c>
    s++;
     528:	84b6                	mv	s1,a3
  ret = *s;
     52a:	03e00a93          	li	s5,62
     52e:	bf59                	j	4c4 <gettoken+0x7c>
  switch(*s){
     530:	07c00713          	li	a4,124
     534:	f8e787e3          	beq	a5,a4,4c2 <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     538:	00002997          	auipc	s3,0x2
     53c:	28098993          	addi	s3,s3,640 # 27b8 <whitespace>
     540:	00002a97          	auipc	s5,0x2
     544:	270a8a93          	addi	s5,s5,624 # 27b0 <symbols>
     548:	0524f163          	bgeu	s1,s2,58a <gettoken+0x142>
     54c:	0004c583          	lbu	a1,0(s1)
     550:	854e                	mv	a0,s3
     552:	00000097          	auipc	ra,0x0
     556:	73c080e7          	jalr	1852(ra) # c8e <strchr>
     55a:	e50d                	bnez	a0,584 <gettoken+0x13c>
     55c:	0004c583          	lbu	a1,0(s1)
     560:	8556                	mv	a0,s5
     562:	00000097          	auipc	ra,0x0
     566:	72c080e7          	jalr	1836(ra) # c8e <strchr>
     56a:	e911                	bnez	a0,57e <gettoken+0x136>
      s++;
     56c:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     56e:	fc991fe3          	bne	s2,s1,54c <gettoken+0x104>
  if(eq)
     572:	84ca                	mv	s1,s2
    ret = 'a';
     574:	06100a93          	li	s5,97
  if(eq)
     578:	f40b18e3          	bnez	s6,4c8 <gettoken+0x80>
     57c:	bf95                	j	4f0 <gettoken+0xa8>
    ret = 'a';
     57e:	06100a93          	li	s5,97
     582:	b789                	j	4c4 <gettoken+0x7c>
     584:	06100a93          	li	s5,97
     588:	bf35                	j	4c4 <gettoken+0x7c>
     58a:	06100a93          	li	s5,97
  if(eq)
     58e:	f20b1de3          	bnez	s6,4c8 <gettoken+0x80>
     592:	bfb9                	j	4f0 <gettoken+0xa8>

0000000000000594 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     594:	7139                	addi	sp,sp,-64
     596:	fc06                	sd	ra,56(sp)
     598:	f822                	sd	s0,48(sp)
     59a:	f426                	sd	s1,40(sp)
     59c:	f04a                	sd	s2,32(sp)
     59e:	ec4e                	sd	s3,24(sp)
     5a0:	e852                	sd	s4,16(sp)
     5a2:	e456                	sd	s5,8(sp)
     5a4:	0080                	addi	s0,sp,64
     5a6:	8a2a                	mv	s4,a0
     5a8:	892e                	mv	s2,a1
     5aa:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     5ac:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     5ae:	00002997          	auipc	s3,0x2
     5b2:	20a98993          	addi	s3,s3,522 # 27b8 <whitespace>
     5b6:	00b4fe63          	bgeu	s1,a1,5d2 <peek+0x3e>
     5ba:	0004c583          	lbu	a1,0(s1)
     5be:	854e                	mv	a0,s3
     5c0:	00000097          	auipc	ra,0x0
     5c4:	6ce080e7          	jalr	1742(ra) # c8e <strchr>
     5c8:	c509                	beqz	a0,5d2 <peek+0x3e>
    s++;
     5ca:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     5cc:	fe9917e3          	bne	s2,s1,5ba <peek+0x26>
     5d0:	84ca                	mv	s1,s2
  *ps = s;
     5d2:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     5d6:	0004c583          	lbu	a1,0(s1)
     5da:	4501                	li	a0,0
     5dc:	e991                	bnez	a1,5f0 <peek+0x5c>
}
     5de:	70e2                	ld	ra,56(sp)
     5e0:	7442                	ld	s0,48(sp)
     5e2:	74a2                	ld	s1,40(sp)
     5e4:	7902                	ld	s2,32(sp)
     5e6:	69e2                	ld	s3,24(sp)
     5e8:	6a42                	ld	s4,16(sp)
     5ea:	6aa2                	ld	s5,8(sp)
     5ec:	6121                	addi	sp,sp,64
     5ee:	8082                	ret
  return *s && strchr(toks, *s);
     5f0:	8556                	mv	a0,s5
     5f2:	00000097          	auipc	ra,0x0
     5f6:	69c080e7          	jalr	1692(ra) # c8e <strchr>
     5fa:	00a03533          	snez	a0,a0
     5fe:	b7c5                	j	5de <peek+0x4a>

0000000000000600 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     600:	711d                	addi	sp,sp,-96
     602:	ec86                	sd	ra,88(sp)
     604:	e8a2                	sd	s0,80(sp)
     606:	e4a6                	sd	s1,72(sp)
     608:	e0ca                	sd	s2,64(sp)
     60a:	fc4e                	sd	s3,56(sp)
     60c:	f852                	sd	s4,48(sp)
     60e:	f456                	sd	s5,40(sp)
     610:	f05a                	sd	s6,32(sp)
     612:	ec5e                	sd	s7,24(sp)
     614:	1080                	addi	s0,sp,96
     616:	8a2a                	mv	s4,a0
     618:	89ae                	mv	s3,a1
     61a:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     61c:	00001a97          	auipc	s5,0x1
     620:	f6ca8a93          	addi	s5,s5,-148 # 1588 <malloc+0x1b4>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     624:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch(tok){
     628:	03c00b93          	li	s7,60
  while(peek(ps, es, "<>")){
     62c:	a02d                	j	656 <parseredirs+0x56>
      panic("missing file for redirection");
     62e:	00001517          	auipc	a0,0x1
     632:	f3a50513          	addi	a0,a0,-198 # 1568 <malloc+0x194>
     636:	00000097          	auipc	ra,0x0
     63a:	a20080e7          	jalr	-1504(ra) # 56 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     63e:	4701                	li	a4,0
     640:	4681                	li	a3,0
     642:	fa043603          	ld	a2,-96(s0)
     646:	fa843583          	ld	a1,-88(s0)
     64a:	8552                	mv	a0,s4
     64c:	00000097          	auipc	ra,0x0
     650:	ccc080e7          	jalr	-820(ra) # 318 <redircmd>
     654:	8a2a                	mv	s4,a0
  while(peek(ps, es, "<>")){
     656:	8656                	mv	a2,s5
     658:	85ca                	mv	a1,s2
     65a:	854e                	mv	a0,s3
     65c:	00000097          	auipc	ra,0x0
     660:	f38080e7          	jalr	-200(ra) # 594 <peek>
     664:	cd25                	beqz	a0,6dc <parseredirs+0xdc>
    tok = gettoken(ps, es, 0, 0);
     666:	4681                	li	a3,0
     668:	4601                	li	a2,0
     66a:	85ca                	mv	a1,s2
     66c:	854e                	mv	a0,s3
     66e:	00000097          	auipc	ra,0x0
     672:	dda080e7          	jalr	-550(ra) # 448 <gettoken>
     676:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     678:	fa040693          	addi	a3,s0,-96
     67c:	fa840613          	addi	a2,s0,-88
     680:	85ca                	mv	a1,s2
     682:	854e                	mv	a0,s3
     684:	00000097          	auipc	ra,0x0
     688:	dc4080e7          	jalr	-572(ra) # 448 <gettoken>
     68c:	fb6511e3          	bne	a0,s6,62e <parseredirs+0x2e>
    switch(tok){
     690:	fb7487e3          	beq	s1,s7,63e <parseredirs+0x3e>
     694:	03e00793          	li	a5,62
     698:	02f48463          	beq	s1,a5,6c0 <parseredirs+0xc0>
     69c:	02b00793          	li	a5,43
     6a0:	faf49be3          	bne	s1,a5,656 <parseredirs+0x56>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6a4:	4705                	li	a4,1
     6a6:	20100693          	li	a3,513
     6aa:	fa043603          	ld	a2,-96(s0)
     6ae:	fa843583          	ld	a1,-88(s0)
     6b2:	8552                	mv	a0,s4
     6b4:	00000097          	auipc	ra,0x0
     6b8:	c64080e7          	jalr	-924(ra) # 318 <redircmd>
     6bc:	8a2a                	mv	s4,a0
      break;
     6be:	bf61                	j	656 <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     6c0:	4705                	li	a4,1
     6c2:	60100693          	li	a3,1537
     6c6:	fa043603          	ld	a2,-96(s0)
     6ca:	fa843583          	ld	a1,-88(s0)
     6ce:	8552                	mv	a0,s4
     6d0:	00000097          	auipc	ra,0x0
     6d4:	c48080e7          	jalr	-952(ra) # 318 <redircmd>
     6d8:	8a2a                	mv	s4,a0
      break;
     6da:	bfb5                	j	656 <parseredirs+0x56>
    }
  }
  return cmd;
}
     6dc:	8552                	mv	a0,s4
     6de:	60e6                	ld	ra,88(sp)
     6e0:	6446                	ld	s0,80(sp)
     6e2:	64a6                	ld	s1,72(sp)
     6e4:	6906                	ld	s2,64(sp)
     6e6:	79e2                	ld	s3,56(sp)
     6e8:	7a42                	ld	s4,48(sp)
     6ea:	7aa2                	ld	s5,40(sp)
     6ec:	7b02                	ld	s6,32(sp)
     6ee:	6be2                	ld	s7,24(sp)
     6f0:	6125                	addi	sp,sp,96
     6f2:	8082                	ret

00000000000006f4 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     6f4:	7159                	addi	sp,sp,-112
     6f6:	f486                	sd	ra,104(sp)
     6f8:	f0a2                	sd	s0,96(sp)
     6fa:	eca6                	sd	s1,88(sp)
     6fc:	e0d2                	sd	s4,64(sp)
     6fe:	fc56                	sd	s5,56(sp)
     700:	1880                	addi	s0,sp,112
     702:	8a2a                	mv	s4,a0
     704:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     706:	00001617          	auipc	a2,0x1
     70a:	e8a60613          	addi	a2,a2,-374 # 1590 <malloc+0x1bc>
     70e:	00000097          	auipc	ra,0x0
     712:	e86080e7          	jalr	-378(ra) # 594 <peek>
     716:	ed15                	bnez	a0,752 <parseexec+0x5e>
     718:	e8ca                	sd	s2,80(sp)
     71a:	e4ce                	sd	s3,72(sp)
     71c:	f85a                	sd	s6,48(sp)
     71e:	f45e                	sd	s7,40(sp)
     720:	f062                	sd	s8,32(sp)
     722:	ec66                	sd	s9,24(sp)
     724:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     726:	00000097          	auipc	ra,0x0
     72a:	bbc080e7          	jalr	-1092(ra) # 2e2 <execcmd>
     72e:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     730:	8656                	mv	a2,s5
     732:	85d2                	mv	a1,s4
     734:	00000097          	auipc	ra,0x0
     738:	ecc080e7          	jalr	-308(ra) # 600 <parseredirs>
     73c:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     73e:	008c0913          	addi	s2,s8,8
     742:	00001b17          	auipc	s6,0x1
     746:	e6eb0b13          	addi	s6,s6,-402 # 15b0 <malloc+0x1dc>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     74a:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     74e:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     750:	a081                	j	790 <parseexec+0x9c>
    return parseblock(ps, es);
     752:	85d6                	mv	a1,s5
     754:	8552                	mv	a0,s4
     756:	00000097          	auipc	ra,0x0
     75a:	1bc080e7          	jalr	444(ra) # 912 <parseblock>
     75e:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     760:	8526                	mv	a0,s1
     762:	70a6                	ld	ra,104(sp)
     764:	7406                	ld	s0,96(sp)
     766:	64e6                	ld	s1,88(sp)
     768:	6a06                	ld	s4,64(sp)
     76a:	7ae2                	ld	s5,56(sp)
     76c:	6165                	addi	sp,sp,112
     76e:	8082                	ret
      panic("syntax");
     770:	00001517          	auipc	a0,0x1
     774:	e2850513          	addi	a0,a0,-472 # 1598 <malloc+0x1c4>
     778:	00000097          	auipc	ra,0x0
     77c:	8de080e7          	jalr	-1826(ra) # 56 <panic>
    ret = parseredirs(ret, ps, es);
     780:	8656                	mv	a2,s5
     782:	85d2                	mv	a1,s4
     784:	8526                	mv	a0,s1
     786:	00000097          	auipc	ra,0x0
     78a:	e7a080e7          	jalr	-390(ra) # 600 <parseredirs>
     78e:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     790:	865a                	mv	a2,s6
     792:	85d6                	mv	a1,s5
     794:	8552                	mv	a0,s4
     796:	00000097          	auipc	ra,0x0
     79a:	dfe080e7          	jalr	-514(ra) # 594 <peek>
     79e:	e131                	bnez	a0,7e2 <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     7a0:	f9040693          	addi	a3,s0,-112
     7a4:	f9840613          	addi	a2,s0,-104
     7a8:	85d6                	mv	a1,s5
     7aa:	8552                	mv	a0,s4
     7ac:	00000097          	auipc	ra,0x0
     7b0:	c9c080e7          	jalr	-868(ra) # 448 <gettoken>
     7b4:	c51d                	beqz	a0,7e2 <parseexec+0xee>
    if(tok != 'a')
     7b6:	fb951de3          	bne	a0,s9,770 <parseexec+0x7c>
    cmd->argv[argc] = q;
     7ba:	f9843783          	ld	a5,-104(s0)
     7be:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     7c2:	f9043783          	ld	a5,-112(s0)
     7c6:	04f93823          	sd	a5,80(s2)
    argc++;
     7ca:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     7cc:	0921                	addi	s2,s2,8
     7ce:	fb7999e3          	bne	s3,s7,780 <parseexec+0x8c>
      panic("too many args");
     7d2:	00001517          	auipc	a0,0x1
     7d6:	dce50513          	addi	a0,a0,-562 # 15a0 <malloc+0x1cc>
     7da:	00000097          	auipc	ra,0x0
     7de:	87c080e7          	jalr	-1924(ra) # 56 <panic>
  cmd->argv[argc] = 0;
     7e2:	098e                	slli	s3,s3,0x3
     7e4:	9c4e                	add	s8,s8,s3
     7e6:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     7ea:	040c3c23          	sd	zero,88(s8)
     7ee:	6946                	ld	s2,80(sp)
     7f0:	69a6                	ld	s3,72(sp)
     7f2:	7b42                	ld	s6,48(sp)
     7f4:	7ba2                	ld	s7,40(sp)
     7f6:	7c02                	ld	s8,32(sp)
     7f8:	6ce2                	ld	s9,24(sp)
  return ret;
     7fa:	b79d                	j	760 <parseexec+0x6c>

00000000000007fc <parsepipe>:
{
     7fc:	7179                	addi	sp,sp,-48
     7fe:	f406                	sd	ra,40(sp)
     800:	f022                	sd	s0,32(sp)
     802:	ec26                	sd	s1,24(sp)
     804:	e84a                	sd	s2,16(sp)
     806:	e44e                	sd	s3,8(sp)
     808:	1800                	addi	s0,sp,48
     80a:	892a                	mv	s2,a0
     80c:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     80e:	00000097          	auipc	ra,0x0
     812:	ee6080e7          	jalr	-282(ra) # 6f4 <parseexec>
     816:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     818:	00001617          	auipc	a2,0x1
     81c:	da060613          	addi	a2,a2,-608 # 15b8 <malloc+0x1e4>
     820:	85ce                	mv	a1,s3
     822:	854a                	mv	a0,s2
     824:	00000097          	auipc	ra,0x0
     828:	d70080e7          	jalr	-656(ra) # 594 <peek>
     82c:	e909                	bnez	a0,83e <parsepipe+0x42>
}
     82e:	8526                	mv	a0,s1
     830:	70a2                	ld	ra,40(sp)
     832:	7402                	ld	s0,32(sp)
     834:	64e2                	ld	s1,24(sp)
     836:	6942                	ld	s2,16(sp)
     838:	69a2                	ld	s3,8(sp)
     83a:	6145                	addi	sp,sp,48
     83c:	8082                	ret
    gettoken(ps, es, 0, 0);
     83e:	4681                	li	a3,0
     840:	4601                	li	a2,0
     842:	85ce                	mv	a1,s3
     844:	854a                	mv	a0,s2
     846:	00000097          	auipc	ra,0x0
     84a:	c02080e7          	jalr	-1022(ra) # 448 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     84e:	85ce                	mv	a1,s3
     850:	854a                	mv	a0,s2
     852:	00000097          	auipc	ra,0x0
     856:	faa080e7          	jalr	-86(ra) # 7fc <parsepipe>
     85a:	85aa                	mv	a1,a0
     85c:	8526                	mv	a0,s1
     85e:	00000097          	auipc	ra,0x0
     862:	b22080e7          	jalr	-1246(ra) # 380 <pipecmd>
     866:	84aa                	mv	s1,a0
  return cmd;
     868:	b7d9                	j	82e <parsepipe+0x32>

000000000000086a <parseline>:
{
     86a:	7179                	addi	sp,sp,-48
     86c:	f406                	sd	ra,40(sp)
     86e:	f022                	sd	s0,32(sp)
     870:	ec26                	sd	s1,24(sp)
     872:	e84a                	sd	s2,16(sp)
     874:	e44e                	sd	s3,8(sp)
     876:	e052                	sd	s4,0(sp)
     878:	1800                	addi	s0,sp,48
     87a:	892a                	mv	s2,a0
     87c:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     87e:	00000097          	auipc	ra,0x0
     882:	f7e080e7          	jalr	-130(ra) # 7fc <parsepipe>
     886:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     888:	00001a17          	auipc	s4,0x1
     88c:	d38a0a13          	addi	s4,s4,-712 # 15c0 <malloc+0x1ec>
     890:	a839                	j	8ae <parseline+0x44>
    gettoken(ps, es, 0, 0);
     892:	4681                	li	a3,0
     894:	4601                	li	a2,0
     896:	85ce                	mv	a1,s3
     898:	854a                	mv	a0,s2
     89a:	00000097          	auipc	ra,0x0
     89e:	bae080e7          	jalr	-1106(ra) # 448 <gettoken>
    cmd = backcmd(cmd);
     8a2:	8526                	mv	a0,s1
     8a4:	00000097          	auipc	ra,0x0
     8a8:	b68080e7          	jalr	-1176(ra) # 40c <backcmd>
     8ac:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     8ae:	8652                	mv	a2,s4
     8b0:	85ce                	mv	a1,s3
     8b2:	854a                	mv	a0,s2
     8b4:	00000097          	auipc	ra,0x0
     8b8:	ce0080e7          	jalr	-800(ra) # 594 <peek>
     8bc:	f979                	bnez	a0,892 <parseline+0x28>
  if(peek(ps, es, ";")){
     8be:	00001617          	auipc	a2,0x1
     8c2:	d0a60613          	addi	a2,a2,-758 # 15c8 <malloc+0x1f4>
     8c6:	85ce                	mv	a1,s3
     8c8:	854a                	mv	a0,s2
     8ca:	00000097          	auipc	ra,0x0
     8ce:	cca080e7          	jalr	-822(ra) # 594 <peek>
     8d2:	e911                	bnez	a0,8e6 <parseline+0x7c>
}
     8d4:	8526                	mv	a0,s1
     8d6:	70a2                	ld	ra,40(sp)
     8d8:	7402                	ld	s0,32(sp)
     8da:	64e2                	ld	s1,24(sp)
     8dc:	6942                	ld	s2,16(sp)
     8de:	69a2                	ld	s3,8(sp)
     8e0:	6a02                	ld	s4,0(sp)
     8e2:	6145                	addi	sp,sp,48
     8e4:	8082                	ret
    gettoken(ps, es, 0, 0);
     8e6:	4681                	li	a3,0
     8e8:	4601                	li	a2,0
     8ea:	85ce                	mv	a1,s3
     8ec:	854a                	mv	a0,s2
     8ee:	00000097          	auipc	ra,0x0
     8f2:	b5a080e7          	jalr	-1190(ra) # 448 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     8f6:	85ce                	mv	a1,s3
     8f8:	854a                	mv	a0,s2
     8fa:	00000097          	auipc	ra,0x0
     8fe:	f70080e7          	jalr	-144(ra) # 86a <parseline>
     902:	85aa                	mv	a1,a0
     904:	8526                	mv	a0,s1
     906:	00000097          	auipc	ra,0x0
     90a:	ac0080e7          	jalr	-1344(ra) # 3c6 <listcmd>
     90e:	84aa                	mv	s1,a0
  return cmd;
     910:	b7d1                	j	8d4 <parseline+0x6a>

0000000000000912 <parseblock>:
{
     912:	7179                	addi	sp,sp,-48
     914:	f406                	sd	ra,40(sp)
     916:	f022                	sd	s0,32(sp)
     918:	ec26                	sd	s1,24(sp)
     91a:	e84a                	sd	s2,16(sp)
     91c:	e44e                	sd	s3,8(sp)
     91e:	1800                	addi	s0,sp,48
     920:	84aa                	mv	s1,a0
     922:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     924:	00001617          	auipc	a2,0x1
     928:	c6c60613          	addi	a2,a2,-916 # 1590 <malloc+0x1bc>
     92c:	00000097          	auipc	ra,0x0
     930:	c68080e7          	jalr	-920(ra) # 594 <peek>
     934:	c12d                	beqz	a0,996 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     936:	4681                	li	a3,0
     938:	4601                	li	a2,0
     93a:	85ca                	mv	a1,s2
     93c:	8526                	mv	a0,s1
     93e:	00000097          	auipc	ra,0x0
     942:	b0a080e7          	jalr	-1270(ra) # 448 <gettoken>
  cmd = parseline(ps, es);
     946:	85ca                	mv	a1,s2
     948:	8526                	mv	a0,s1
     94a:	00000097          	auipc	ra,0x0
     94e:	f20080e7          	jalr	-224(ra) # 86a <parseline>
     952:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     954:	00001617          	auipc	a2,0x1
     958:	c8c60613          	addi	a2,a2,-884 # 15e0 <malloc+0x20c>
     95c:	85ca                	mv	a1,s2
     95e:	8526                	mv	a0,s1
     960:	00000097          	auipc	ra,0x0
     964:	c34080e7          	jalr	-972(ra) # 594 <peek>
     968:	cd1d                	beqz	a0,9a6 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     96a:	4681                	li	a3,0
     96c:	4601                	li	a2,0
     96e:	85ca                	mv	a1,s2
     970:	8526                	mv	a0,s1
     972:	00000097          	auipc	ra,0x0
     976:	ad6080e7          	jalr	-1322(ra) # 448 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     97a:	864a                	mv	a2,s2
     97c:	85a6                	mv	a1,s1
     97e:	854e                	mv	a0,s3
     980:	00000097          	auipc	ra,0x0
     984:	c80080e7          	jalr	-896(ra) # 600 <parseredirs>
}
     988:	70a2                	ld	ra,40(sp)
     98a:	7402                	ld	s0,32(sp)
     98c:	64e2                	ld	s1,24(sp)
     98e:	6942                	ld	s2,16(sp)
     990:	69a2                	ld	s3,8(sp)
     992:	6145                	addi	sp,sp,48
     994:	8082                	ret
    panic("parseblock");
     996:	00001517          	auipc	a0,0x1
     99a:	c3a50513          	addi	a0,a0,-966 # 15d0 <malloc+0x1fc>
     99e:	fffff097          	auipc	ra,0xfffff
     9a2:	6b8080e7          	jalr	1720(ra) # 56 <panic>
    panic("syntax - missing )");
     9a6:	00001517          	auipc	a0,0x1
     9aa:	c4250513          	addi	a0,a0,-958 # 15e8 <malloc+0x214>
     9ae:	fffff097          	auipc	ra,0xfffff
     9b2:	6a8080e7          	jalr	1704(ra) # 56 <panic>

00000000000009b6 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     9b6:	1101                	addi	sp,sp,-32
     9b8:	ec06                	sd	ra,24(sp)
     9ba:	e822                	sd	s0,16(sp)
     9bc:	e426                	sd	s1,8(sp)
     9be:	1000                	addi	s0,sp,32
     9c0:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     9c2:	c521                	beqz	a0,a0a <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     9c4:	4118                	lw	a4,0(a0)
     9c6:	4795                	li	a5,5
     9c8:	04e7e163          	bltu	a5,a4,a0a <nulterminate+0x54>
     9cc:	00056783          	lwu	a5,0(a0)
     9d0:	078a                	slli	a5,a5,0x2
     9d2:	00001717          	auipc	a4,0x1
     9d6:	c7670713          	addi	a4,a4,-906 # 1648 <malloc+0x274>
     9da:	97ba                	add	a5,a5,a4
     9dc:	439c                	lw	a5,0(a5)
     9de:	97ba                	add	a5,a5,a4
     9e0:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     9e2:	651c                	ld	a5,8(a0)
     9e4:	c39d                	beqz	a5,a0a <nulterminate+0x54>
     9e6:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     9ea:	67b8                	ld	a4,72(a5)
     9ec:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     9f0:	07a1                	addi	a5,a5,8
     9f2:	ff87b703          	ld	a4,-8(a5)
     9f6:	fb75                	bnez	a4,9ea <nulterminate+0x34>
     9f8:	a809                	j	a0a <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     9fa:	6508                	ld	a0,8(a0)
     9fc:	00000097          	auipc	ra,0x0
     a00:	fba080e7          	jalr	-70(ra) # 9b6 <nulterminate>
    *rcmd->efile = 0;
     a04:	6c9c                	ld	a5,24(s1)
     a06:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a0a:	8526                	mv	a0,s1
     a0c:	60e2                	ld	ra,24(sp)
     a0e:	6442                	ld	s0,16(sp)
     a10:	64a2                	ld	s1,8(sp)
     a12:	6105                	addi	sp,sp,32
     a14:	8082                	ret
    nulterminate(pcmd->left);
     a16:	6508                	ld	a0,8(a0)
     a18:	00000097          	auipc	ra,0x0
     a1c:	f9e080e7          	jalr	-98(ra) # 9b6 <nulterminate>
    nulterminate(pcmd->right);
     a20:	6888                	ld	a0,16(s1)
     a22:	00000097          	auipc	ra,0x0
     a26:	f94080e7          	jalr	-108(ra) # 9b6 <nulterminate>
    break;
     a2a:	b7c5                	j	a0a <nulterminate+0x54>
    nulterminate(lcmd->left);
     a2c:	6508                	ld	a0,8(a0)
     a2e:	00000097          	auipc	ra,0x0
     a32:	f88080e7          	jalr	-120(ra) # 9b6 <nulterminate>
    nulterminate(lcmd->right);
     a36:	6888                	ld	a0,16(s1)
     a38:	00000097          	auipc	ra,0x0
     a3c:	f7e080e7          	jalr	-130(ra) # 9b6 <nulterminate>
    break;
     a40:	b7e9                	j	a0a <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     a42:	6508                	ld	a0,8(a0)
     a44:	00000097          	auipc	ra,0x0
     a48:	f72080e7          	jalr	-142(ra) # 9b6 <nulterminate>
    break;
     a4c:	bf7d                	j	a0a <nulterminate+0x54>

0000000000000a4e <parsecmd>:
{
     a4e:	7179                	addi	sp,sp,-48
     a50:	f406                	sd	ra,40(sp)
     a52:	f022                	sd	s0,32(sp)
     a54:	ec26                	sd	s1,24(sp)
     a56:	e84a                	sd	s2,16(sp)
     a58:	1800                	addi	s0,sp,48
     a5a:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     a5e:	84aa                	mv	s1,a0
     a60:	00000097          	auipc	ra,0x0
     a64:	1e2080e7          	jalr	482(ra) # c42 <strlen>
     a68:	1502                	slli	a0,a0,0x20
     a6a:	9101                	srli	a0,a0,0x20
     a6c:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a6e:	85a6                	mv	a1,s1
     a70:	fd840513          	addi	a0,s0,-40
     a74:	00000097          	auipc	ra,0x0
     a78:	df6080e7          	jalr	-522(ra) # 86a <parseline>
     a7c:	892a                	mv	s2,a0
  peek(&s, es, "");
     a7e:	00001617          	auipc	a2,0x1
     a82:	a9a60613          	addi	a2,a2,-1382 # 1518 <malloc+0x144>
     a86:	85a6                	mv	a1,s1
     a88:	fd840513          	addi	a0,s0,-40
     a8c:	00000097          	auipc	ra,0x0
     a90:	b08080e7          	jalr	-1272(ra) # 594 <peek>
  if(s != es){
     a94:	fd843603          	ld	a2,-40(s0)
     a98:	00961e63          	bne	a2,s1,ab4 <parsecmd+0x66>
  nulterminate(cmd);
     a9c:	854a                	mv	a0,s2
     a9e:	00000097          	auipc	ra,0x0
     aa2:	f18080e7          	jalr	-232(ra) # 9b6 <nulterminate>
}
     aa6:	854a                	mv	a0,s2
     aa8:	70a2                	ld	ra,40(sp)
     aaa:	7402                	ld	s0,32(sp)
     aac:	64e2                	ld	s1,24(sp)
     aae:	6942                	ld	s2,16(sp)
     ab0:	6145                	addi	sp,sp,48
     ab2:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     ab4:	00001597          	auipc	a1,0x1
     ab8:	b4c58593          	addi	a1,a1,-1204 # 1600 <malloc+0x22c>
     abc:	4509                	li	a0,2
     abe:	00000097          	auipc	ra,0x0
     ac2:	6fa080e7          	jalr	1786(ra) # 11b8 <fprintf>
    panic("syntax");
     ac6:	00001517          	auipc	a0,0x1
     aca:	ad250513          	addi	a0,a0,-1326 # 1598 <malloc+0x1c4>
     ace:	fffff097          	auipc	ra,0xfffff
     ad2:	588080e7          	jalr	1416(ra) # 56 <panic>

0000000000000ad6 <main>:
{
     ad6:	7179                	addi	sp,sp,-48
     ad8:	f406                	sd	ra,40(sp)
     ada:	f022                	sd	s0,32(sp)
     adc:	ec26                	sd	s1,24(sp)
     ade:	e84a                	sd	s2,16(sp)
     ae0:	e44e                	sd	s3,8(sp)
     ae2:	e052                	sd	s4,0(sp)
     ae4:	1800                	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     ae6:	00001497          	auipc	s1,0x1
     aea:	b2a48493          	addi	s1,s1,-1238 # 1610 <malloc+0x23c>
     aee:	4589                	li	a1,2
     af0:	8526                	mv	a0,s1
     af2:	00000097          	auipc	ra,0x0
     af6:	3b4080e7          	jalr	948(ra) # ea6 <open>
     afa:	00054963          	bltz	a0,b0c <main+0x36>
    if(fd >= 3){
     afe:	4789                	li	a5,2
     b00:	fea7d7e3          	bge	a5,a0,aee <main+0x18>
      close(fd);
     b04:	00000097          	auipc	ra,0x0
     b08:	38a080e7          	jalr	906(ra) # e8e <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     b0c:	00002917          	auipc	s2,0x2
     b10:	d1c90913          	addi	s2,s2,-740 # 2828 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     b14:	00002497          	auipc	s1,0x2
     b18:	cac48493          	addi	s1,s1,-852 # 27c0 <tmp.1>
     b1c:	06300993          	li	s3,99
     b20:	02000a13          	li	s4,32
     b24:	a819                	j	b3a <main+0x64>
    if(fork1() == 0)
     b26:	fffff097          	auipc	ra,0xfffff
     b2a:	556080e7          	jalr	1366(ra) # 7c <fork1>
     b2e:	c941                	beqz	a0,bbe <main+0xe8>
    wait(0);
     b30:	4501                	li	a0,0
     b32:	00000097          	auipc	ra,0x0
     b36:	33c080e7          	jalr	828(ra) # e6e <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     b3a:	06400593          	li	a1,100
     b3e:	854a                	mv	a0,s2
     b40:	fffff097          	auipc	ra,0xfffff
     b44:	4c0080e7          	jalr	1216(ra) # 0 <getcmd>
     b48:	08054763          	bltz	a0,bd6 <main+0x100>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     b4c:	0684c783          	lbu	a5,104(s1)
     b50:	fd379be3          	bne	a5,s3,b26 <main+0x50>
     b54:	0694c703          	lbu	a4,105(s1)
     b58:	06400793          	li	a5,100
     b5c:	fcf715e3          	bne	a4,a5,b26 <main+0x50>
     b60:	06a4c783          	lbu	a5,106(s1)
     b64:	fd4791e3          	bne	a5,s4,b26 <main+0x50>
      buf[strlen(buf)-1] = 0;  // chop \n
     b68:	00002517          	auipc	a0,0x2
     b6c:	cc050513          	addi	a0,a0,-832 # 2828 <buf.0>
     b70:	00000097          	auipc	ra,0x0
     b74:	0d2080e7          	jalr	210(ra) # c42 <strlen>
     b78:	fff5079b          	addiw	a5,a0,-1
     b7c:	1782                	slli	a5,a5,0x20
     b7e:	9381                	srli	a5,a5,0x20
     b80:	00002717          	auipc	a4,0x2
     b84:	c4070713          	addi	a4,a4,-960 # 27c0 <tmp.1>
     b88:	97ba                	add	a5,a5,a4
     b8a:	06078423          	sb	zero,104(a5)
      if(chdir(buf+3) < 0)
     b8e:	00002517          	auipc	a0,0x2
     b92:	c9d50513          	addi	a0,a0,-867 # 282b <buf.0+0x3>
     b96:	00000097          	auipc	ra,0x0
     b9a:	340080e7          	jalr	832(ra) # ed6 <chdir>
     b9e:	f8055ee3          	bgez	a0,b3a <main+0x64>
        fprintf(2, "cannot cd %s\n", buf+3);
     ba2:	00002617          	auipc	a2,0x2
     ba6:	c8960613          	addi	a2,a2,-887 # 282b <buf.0+0x3>
     baa:	00001597          	auipc	a1,0x1
     bae:	a6e58593          	addi	a1,a1,-1426 # 1618 <malloc+0x244>
     bb2:	4509                	li	a0,2
     bb4:	00000097          	auipc	ra,0x0
     bb8:	604080e7          	jalr	1540(ra) # 11b8 <fprintf>
     bbc:	bfbd                	j	b3a <main+0x64>
      runcmd(parsecmd(buf));
     bbe:	00002517          	auipc	a0,0x2
     bc2:	c6a50513          	addi	a0,a0,-918 # 2828 <buf.0>
     bc6:	00000097          	auipc	ra,0x0
     bca:	e88080e7          	jalr	-376(ra) # a4e <parsecmd>
     bce:	fffff097          	auipc	ra,0xfffff
     bd2:	4dc080e7          	jalr	1244(ra) # aa <runcmd>
  exit(0);
     bd6:	4501                	li	a0,0
     bd8:	00000097          	auipc	ra,0x0
     bdc:	28e080e7          	jalr	654(ra) # e66 <exit>

0000000000000be0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     be0:	1141                	addi	sp,sp,-16
     be2:	e406                	sd	ra,8(sp)
     be4:	e022                	sd	s0,0(sp)
     be6:	0800                	addi	s0,sp,16
  extern int main();
  main();
     be8:	00000097          	auipc	ra,0x0
     bec:	eee080e7          	jalr	-274(ra) # ad6 <main>
  exit(0);
     bf0:	4501                	li	a0,0
     bf2:	00000097          	auipc	ra,0x0
     bf6:	274080e7          	jalr	628(ra) # e66 <exit>

0000000000000bfa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bfa:	1141                	addi	sp,sp,-16
     bfc:	e422                	sd	s0,8(sp)
     bfe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c00:	87aa                	mv	a5,a0
     c02:	0585                	addi	a1,a1,1
     c04:	0785                	addi	a5,a5,1
     c06:	fff5c703          	lbu	a4,-1(a1)
     c0a:	fee78fa3          	sb	a4,-1(a5)
     c0e:	fb75                	bnez	a4,c02 <strcpy+0x8>
    ;
  return os;
}
     c10:	6422                	ld	s0,8(sp)
     c12:	0141                	addi	sp,sp,16
     c14:	8082                	ret

0000000000000c16 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c16:	1141                	addi	sp,sp,-16
     c18:	e422                	sd	s0,8(sp)
     c1a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c1c:	00054783          	lbu	a5,0(a0)
     c20:	cb91                	beqz	a5,c34 <strcmp+0x1e>
     c22:	0005c703          	lbu	a4,0(a1)
     c26:	00f71763          	bne	a4,a5,c34 <strcmp+0x1e>
    p++, q++;
     c2a:	0505                	addi	a0,a0,1
     c2c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c2e:	00054783          	lbu	a5,0(a0)
     c32:	fbe5                	bnez	a5,c22 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c34:	0005c503          	lbu	a0,0(a1)
}
     c38:	40a7853b          	subw	a0,a5,a0
     c3c:	6422                	ld	s0,8(sp)
     c3e:	0141                	addi	sp,sp,16
     c40:	8082                	ret

0000000000000c42 <strlen>:

uint
strlen(const char *s)
{
     c42:	1141                	addi	sp,sp,-16
     c44:	e422                	sd	s0,8(sp)
     c46:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c48:	00054783          	lbu	a5,0(a0)
     c4c:	cf91                	beqz	a5,c68 <strlen+0x26>
     c4e:	0505                	addi	a0,a0,1
     c50:	87aa                	mv	a5,a0
     c52:	86be                	mv	a3,a5
     c54:	0785                	addi	a5,a5,1
     c56:	fff7c703          	lbu	a4,-1(a5)
     c5a:	ff65                	bnez	a4,c52 <strlen+0x10>
     c5c:	40a6853b          	subw	a0,a3,a0
     c60:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     c62:	6422                	ld	s0,8(sp)
     c64:	0141                	addi	sp,sp,16
     c66:	8082                	ret
  for(n = 0; s[n]; n++)
     c68:	4501                	li	a0,0
     c6a:	bfe5                	j	c62 <strlen+0x20>

0000000000000c6c <memset>:

void*
memset(void *dst, int c, uint n)
{
     c6c:	1141                	addi	sp,sp,-16
     c6e:	e422                	sd	s0,8(sp)
     c70:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c72:	ca19                	beqz	a2,c88 <memset+0x1c>
     c74:	87aa                	mv	a5,a0
     c76:	1602                	slli	a2,a2,0x20
     c78:	9201                	srli	a2,a2,0x20
     c7a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c7e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c82:	0785                	addi	a5,a5,1
     c84:	fee79de3          	bne	a5,a4,c7e <memset+0x12>
  }
  return dst;
}
     c88:	6422                	ld	s0,8(sp)
     c8a:	0141                	addi	sp,sp,16
     c8c:	8082                	ret

0000000000000c8e <strchr>:

char*
strchr(const char *s, char c)
{
     c8e:	1141                	addi	sp,sp,-16
     c90:	e422                	sd	s0,8(sp)
     c92:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c94:	00054783          	lbu	a5,0(a0)
     c98:	cb99                	beqz	a5,cae <strchr+0x20>
    if(*s == c)
     c9a:	00f58763          	beq	a1,a5,ca8 <strchr+0x1a>
  for(; *s; s++)
     c9e:	0505                	addi	a0,a0,1
     ca0:	00054783          	lbu	a5,0(a0)
     ca4:	fbfd                	bnez	a5,c9a <strchr+0xc>
      return (char*)s;
  return 0;
     ca6:	4501                	li	a0,0
}
     ca8:	6422                	ld	s0,8(sp)
     caa:	0141                	addi	sp,sp,16
     cac:	8082                	ret
  return 0;
     cae:	4501                	li	a0,0
     cb0:	bfe5                	j	ca8 <strchr+0x1a>

0000000000000cb2 <gets>:

char*
gets(char *buf, int max)
{
     cb2:	711d                	addi	sp,sp,-96
     cb4:	ec86                	sd	ra,88(sp)
     cb6:	e8a2                	sd	s0,80(sp)
     cb8:	e4a6                	sd	s1,72(sp)
     cba:	e0ca                	sd	s2,64(sp)
     cbc:	fc4e                	sd	s3,56(sp)
     cbe:	f852                	sd	s4,48(sp)
     cc0:	f456                	sd	s5,40(sp)
     cc2:	f05a                	sd	s6,32(sp)
     cc4:	ec5e                	sd	s7,24(sp)
     cc6:	1080                	addi	s0,sp,96
     cc8:	8baa                	mv	s7,a0
     cca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ccc:	892a                	mv	s2,a0
     cce:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     cd0:	4aa9                	li	s5,10
     cd2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cd4:	89a6                	mv	s3,s1
     cd6:	2485                	addiw	s1,s1,1
     cd8:	0344d863          	bge	s1,s4,d08 <gets+0x56>
    cc = read(0, &c, 1);
     cdc:	4605                	li	a2,1
     cde:	faf40593          	addi	a1,s0,-81
     ce2:	4501                	li	a0,0
     ce4:	00000097          	auipc	ra,0x0
     ce8:	19a080e7          	jalr	410(ra) # e7e <read>
    if(cc < 1)
     cec:	00a05e63          	blez	a0,d08 <gets+0x56>
    buf[i++] = c;
     cf0:	faf44783          	lbu	a5,-81(s0)
     cf4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cf8:	01578763          	beq	a5,s5,d06 <gets+0x54>
     cfc:	0905                	addi	s2,s2,1
     cfe:	fd679be3          	bne	a5,s6,cd4 <gets+0x22>
    buf[i++] = c;
     d02:	89a6                	mv	s3,s1
     d04:	a011                	j	d08 <gets+0x56>
     d06:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     d08:	99de                	add	s3,s3,s7
     d0a:	00098023          	sb	zero,0(s3)
  return buf;
}
     d0e:	855e                	mv	a0,s7
     d10:	60e6                	ld	ra,88(sp)
     d12:	6446                	ld	s0,80(sp)
     d14:	64a6                	ld	s1,72(sp)
     d16:	6906                	ld	s2,64(sp)
     d18:	79e2                	ld	s3,56(sp)
     d1a:	7a42                	ld	s4,48(sp)
     d1c:	7aa2                	ld	s5,40(sp)
     d1e:	7b02                	ld	s6,32(sp)
     d20:	6be2                	ld	s7,24(sp)
     d22:	6125                	addi	sp,sp,96
     d24:	8082                	ret

0000000000000d26 <stat>:

int
stat(const char *n, struct stat *st)
{
     d26:	1101                	addi	sp,sp,-32
     d28:	ec06                	sd	ra,24(sp)
     d2a:	e822                	sd	s0,16(sp)
     d2c:	e04a                	sd	s2,0(sp)
     d2e:	1000                	addi	s0,sp,32
     d30:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d32:	4581                	li	a1,0
     d34:	00000097          	auipc	ra,0x0
     d38:	172080e7          	jalr	370(ra) # ea6 <open>
  if(fd < 0)
     d3c:	02054663          	bltz	a0,d68 <stat+0x42>
     d40:	e426                	sd	s1,8(sp)
     d42:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d44:	85ca                	mv	a1,s2
     d46:	00000097          	auipc	ra,0x0
     d4a:	178080e7          	jalr	376(ra) # ebe <fstat>
     d4e:	892a                	mv	s2,a0
  close(fd);
     d50:	8526                	mv	a0,s1
     d52:	00000097          	auipc	ra,0x0
     d56:	13c080e7          	jalr	316(ra) # e8e <close>
  return r;
     d5a:	64a2                	ld	s1,8(sp)
}
     d5c:	854a                	mv	a0,s2
     d5e:	60e2                	ld	ra,24(sp)
     d60:	6442                	ld	s0,16(sp)
     d62:	6902                	ld	s2,0(sp)
     d64:	6105                	addi	sp,sp,32
     d66:	8082                	ret
    return -1;
     d68:	597d                	li	s2,-1
     d6a:	bfcd                	j	d5c <stat+0x36>

0000000000000d6c <atoi>:

int
atoi(const char *s)
{
     d6c:	1141                	addi	sp,sp,-16
     d6e:	e422                	sd	s0,8(sp)
     d70:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d72:	00054683          	lbu	a3,0(a0)
     d76:	fd06879b          	addiw	a5,a3,-48
     d7a:	0ff7f793          	zext.b	a5,a5
     d7e:	4625                	li	a2,9
     d80:	02f66863          	bltu	a2,a5,db0 <atoi+0x44>
     d84:	872a                	mv	a4,a0
  n = 0;
     d86:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d88:	0705                	addi	a4,a4,1
     d8a:	0025179b          	slliw	a5,a0,0x2
     d8e:	9fa9                	addw	a5,a5,a0
     d90:	0017979b          	slliw	a5,a5,0x1
     d94:	9fb5                	addw	a5,a5,a3
     d96:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d9a:	00074683          	lbu	a3,0(a4)
     d9e:	fd06879b          	addiw	a5,a3,-48
     da2:	0ff7f793          	zext.b	a5,a5
     da6:	fef671e3          	bgeu	a2,a5,d88 <atoi+0x1c>
  return n;
}
     daa:	6422                	ld	s0,8(sp)
     dac:	0141                	addi	sp,sp,16
     dae:	8082                	ret
  n = 0;
     db0:	4501                	li	a0,0
     db2:	bfe5                	j	daa <atoi+0x3e>

0000000000000db4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     db4:	1141                	addi	sp,sp,-16
     db6:	e422                	sd	s0,8(sp)
     db8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     dba:	02b57463          	bgeu	a0,a1,de2 <memmove+0x2e>
    while(n-- > 0)
     dbe:	00c05f63          	blez	a2,ddc <memmove+0x28>
     dc2:	1602                	slli	a2,a2,0x20
     dc4:	9201                	srli	a2,a2,0x20
     dc6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     dca:	872a                	mv	a4,a0
      *dst++ = *src++;
     dcc:	0585                	addi	a1,a1,1
     dce:	0705                	addi	a4,a4,1
     dd0:	fff5c683          	lbu	a3,-1(a1)
     dd4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     dd8:	fef71ae3          	bne	a4,a5,dcc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ddc:	6422                	ld	s0,8(sp)
     dde:	0141                	addi	sp,sp,16
     de0:	8082                	ret
    dst += n;
     de2:	00c50733          	add	a4,a0,a2
    src += n;
     de6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     de8:	fec05ae3          	blez	a2,ddc <memmove+0x28>
     dec:	fff6079b          	addiw	a5,a2,-1
     df0:	1782                	slli	a5,a5,0x20
     df2:	9381                	srli	a5,a5,0x20
     df4:	fff7c793          	not	a5,a5
     df8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dfa:	15fd                	addi	a1,a1,-1
     dfc:	177d                	addi	a4,a4,-1
     dfe:	0005c683          	lbu	a3,0(a1)
     e02:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e06:	fee79ae3          	bne	a5,a4,dfa <memmove+0x46>
     e0a:	bfc9                	j	ddc <memmove+0x28>

0000000000000e0c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e0c:	1141                	addi	sp,sp,-16
     e0e:	e422                	sd	s0,8(sp)
     e10:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e12:	ca05                	beqz	a2,e42 <memcmp+0x36>
     e14:	fff6069b          	addiw	a3,a2,-1
     e18:	1682                	slli	a3,a3,0x20
     e1a:	9281                	srli	a3,a3,0x20
     e1c:	0685                	addi	a3,a3,1
     e1e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e20:	00054783          	lbu	a5,0(a0)
     e24:	0005c703          	lbu	a4,0(a1)
     e28:	00e79863          	bne	a5,a4,e38 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e2c:	0505                	addi	a0,a0,1
    p2++;
     e2e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e30:	fed518e3          	bne	a0,a3,e20 <memcmp+0x14>
  }
  return 0;
     e34:	4501                	li	a0,0
     e36:	a019                	j	e3c <memcmp+0x30>
      return *p1 - *p2;
     e38:	40e7853b          	subw	a0,a5,a4
}
     e3c:	6422                	ld	s0,8(sp)
     e3e:	0141                	addi	sp,sp,16
     e40:	8082                	ret
  return 0;
     e42:	4501                	li	a0,0
     e44:	bfe5                	j	e3c <memcmp+0x30>

0000000000000e46 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e46:	1141                	addi	sp,sp,-16
     e48:	e406                	sd	ra,8(sp)
     e4a:	e022                	sd	s0,0(sp)
     e4c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e4e:	00000097          	auipc	ra,0x0
     e52:	f66080e7          	jalr	-154(ra) # db4 <memmove>
}
     e56:	60a2                	ld	ra,8(sp)
     e58:	6402                	ld	s0,0(sp)
     e5a:	0141                	addi	sp,sp,16
     e5c:	8082                	ret

0000000000000e5e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e5e:	4885                	li	a7,1
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e66:	4889                	li	a7,2
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <wait>:
.global wait
wait:
 li a7, SYS_wait
     e6e:	488d                	li	a7,3
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e76:	4891                	li	a7,4
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <read>:
.global read
read:
 li a7, SYS_read
     e7e:	4895                	li	a7,5
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <write>:
.global write
write:
 li a7, SYS_write
     e86:	48c1                	li	a7,16
 ecall
     e88:	00000073          	ecall
 ret
     e8c:	8082                	ret

0000000000000e8e <close>:
.global close
close:
 li a7, SYS_close
     e8e:	48d5                	li	a7,21
 ecall
     e90:	00000073          	ecall
 ret
     e94:	8082                	ret

0000000000000e96 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e96:	4899                	li	a7,6
 ecall
     e98:	00000073          	ecall
 ret
     e9c:	8082                	ret

0000000000000e9e <exec>:
.global exec
exec:
 li a7, SYS_exec
     e9e:	489d                	li	a7,7
 ecall
     ea0:	00000073          	ecall
 ret
     ea4:	8082                	ret

0000000000000ea6 <open>:
.global open
open:
 li a7, SYS_open
     ea6:	48bd                	li	a7,15
 ecall
     ea8:	00000073          	ecall
 ret
     eac:	8082                	ret

0000000000000eae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     eae:	48c5                	li	a7,17
 ecall
     eb0:	00000073          	ecall
 ret
     eb4:	8082                	ret

0000000000000eb6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     eb6:	48c9                	li	a7,18
 ecall
     eb8:	00000073          	ecall
 ret
     ebc:	8082                	ret

0000000000000ebe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ebe:	48a1                	li	a7,8
 ecall
     ec0:	00000073          	ecall
 ret
     ec4:	8082                	ret

0000000000000ec6 <link>:
.global link
link:
 li a7, SYS_link
     ec6:	48cd                	li	a7,19
 ecall
     ec8:	00000073          	ecall
 ret
     ecc:	8082                	ret

0000000000000ece <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ece:	48d1                	li	a7,20
 ecall
     ed0:	00000073          	ecall
 ret
     ed4:	8082                	ret

0000000000000ed6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ed6:	48a5                	li	a7,9
 ecall
     ed8:	00000073          	ecall
 ret
     edc:	8082                	ret

0000000000000ede <dup>:
.global dup
dup:
 li a7, SYS_dup
     ede:	48a9                	li	a7,10
 ecall
     ee0:	00000073          	ecall
 ret
     ee4:	8082                	ret

0000000000000ee6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ee6:	48ad                	li	a7,11
 ecall
     ee8:	00000073          	ecall
 ret
     eec:	8082                	ret

0000000000000eee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     eee:	48b1                	li	a7,12
 ecall
     ef0:	00000073          	ecall
 ret
     ef4:	8082                	ret

0000000000000ef6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ef6:	48b5                	li	a7,13
 ecall
     ef8:	00000073          	ecall
 ret
     efc:	8082                	ret

0000000000000efe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     efe:	48b9                	li	a7,14
 ecall
     f00:	00000073          	ecall
 ret
     f04:	8082                	ret

0000000000000f06 <yield>:
.global yield
yield:
 li a7, SYS_yield
     f06:	48d9                	li	a7,22
 ecall
     f08:	00000073          	ecall
 ret
     f0c:	8082                	ret

0000000000000f0e <lock>:
.global lock
lock:
 li a7, SYS_lock
     f0e:	48dd                	li	a7,23
 ecall
     f10:	00000073          	ecall
 ret
     f14:	8082                	ret

0000000000000f16 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
     f16:	48e1                	li	a7,24
 ecall
     f18:	00000073          	ecall
 ret
     f1c:	8082                	ret

0000000000000f1e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f1e:	1101                	addi	sp,sp,-32
     f20:	ec06                	sd	ra,24(sp)
     f22:	e822                	sd	s0,16(sp)
     f24:	1000                	addi	s0,sp,32
     f26:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f2a:	4605                	li	a2,1
     f2c:	fef40593          	addi	a1,s0,-17
     f30:	00000097          	auipc	ra,0x0
     f34:	f56080e7          	jalr	-170(ra) # e86 <write>
}
     f38:	60e2                	ld	ra,24(sp)
     f3a:	6442                	ld	s0,16(sp)
     f3c:	6105                	addi	sp,sp,32
     f3e:	8082                	ret

0000000000000f40 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f40:	7139                	addi	sp,sp,-64
     f42:	fc06                	sd	ra,56(sp)
     f44:	f822                	sd	s0,48(sp)
     f46:	f426                	sd	s1,40(sp)
     f48:	0080                	addi	s0,sp,64
     f4a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f4c:	c299                	beqz	a3,f52 <printint+0x12>
     f4e:	0805cb63          	bltz	a1,fe4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f52:	2581                	sext.w	a1,a1
  neg = 0;
     f54:	4881                	li	a7,0
     f56:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f5a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f5c:	2601                	sext.w	a2,a2
     f5e:	00000517          	auipc	a0,0x0
     f62:	75a50513          	addi	a0,a0,1882 # 16b8 <digits>
     f66:	883a                	mv	a6,a4
     f68:	2705                	addiw	a4,a4,1
     f6a:	02c5f7bb          	remuw	a5,a1,a2
     f6e:	1782                	slli	a5,a5,0x20
     f70:	9381                	srli	a5,a5,0x20
     f72:	97aa                	add	a5,a5,a0
     f74:	0007c783          	lbu	a5,0(a5)
     f78:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f7c:	0005879b          	sext.w	a5,a1
     f80:	02c5d5bb          	divuw	a1,a1,a2
     f84:	0685                	addi	a3,a3,1
     f86:	fec7f0e3          	bgeu	a5,a2,f66 <printint+0x26>
  if(neg)
     f8a:	00088c63          	beqz	a7,fa2 <printint+0x62>
    buf[i++] = '-';
     f8e:	fd070793          	addi	a5,a4,-48
     f92:	00878733          	add	a4,a5,s0
     f96:	02d00793          	li	a5,45
     f9a:	fef70823          	sb	a5,-16(a4)
     f9e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     fa2:	02e05c63          	blez	a4,fda <printint+0x9a>
     fa6:	f04a                	sd	s2,32(sp)
     fa8:	ec4e                	sd	s3,24(sp)
     faa:	fc040793          	addi	a5,s0,-64
     fae:	00e78933          	add	s2,a5,a4
     fb2:	fff78993          	addi	s3,a5,-1
     fb6:	99ba                	add	s3,s3,a4
     fb8:	377d                	addiw	a4,a4,-1
     fba:	1702                	slli	a4,a4,0x20
     fbc:	9301                	srli	a4,a4,0x20
     fbe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     fc2:	fff94583          	lbu	a1,-1(s2)
     fc6:	8526                	mv	a0,s1
     fc8:	00000097          	auipc	ra,0x0
     fcc:	f56080e7          	jalr	-170(ra) # f1e <putc>
  while(--i >= 0)
     fd0:	197d                	addi	s2,s2,-1
     fd2:	ff3918e3          	bne	s2,s3,fc2 <printint+0x82>
     fd6:	7902                	ld	s2,32(sp)
     fd8:	69e2                	ld	s3,24(sp)
}
     fda:	70e2                	ld	ra,56(sp)
     fdc:	7442                	ld	s0,48(sp)
     fde:	74a2                	ld	s1,40(sp)
     fe0:	6121                	addi	sp,sp,64
     fe2:	8082                	ret
    x = -xx;
     fe4:	40b005bb          	negw	a1,a1
    neg = 1;
     fe8:	4885                	li	a7,1
    x = -xx;
     fea:	b7b5                	j	f56 <printint+0x16>

0000000000000fec <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fec:	715d                	addi	sp,sp,-80
     fee:	e486                	sd	ra,72(sp)
     ff0:	e0a2                	sd	s0,64(sp)
     ff2:	f84a                	sd	s2,48(sp)
     ff4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ff6:	0005c903          	lbu	s2,0(a1)
     ffa:	1a090a63          	beqz	s2,11ae <vprintf+0x1c2>
     ffe:	fc26                	sd	s1,56(sp)
    1000:	f44e                	sd	s3,40(sp)
    1002:	f052                	sd	s4,32(sp)
    1004:	ec56                	sd	s5,24(sp)
    1006:	e85a                	sd	s6,16(sp)
    1008:	e45e                	sd	s7,8(sp)
    100a:	8aaa                	mv	s5,a0
    100c:	8bb2                	mv	s7,a2
    100e:	00158493          	addi	s1,a1,1
  state = 0;
    1012:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1014:	02500a13          	li	s4,37
    1018:	4b55                	li	s6,21
    101a:	a839                	j	1038 <vprintf+0x4c>
        putc(fd, c);
    101c:	85ca                	mv	a1,s2
    101e:	8556                	mv	a0,s5
    1020:	00000097          	auipc	ra,0x0
    1024:	efe080e7          	jalr	-258(ra) # f1e <putc>
    1028:	a019                	j	102e <vprintf+0x42>
    } else if(state == '%'){
    102a:	01498d63          	beq	s3,s4,1044 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    102e:	0485                	addi	s1,s1,1
    1030:	fff4c903          	lbu	s2,-1(s1)
    1034:	16090763          	beqz	s2,11a2 <vprintf+0x1b6>
    if(state == 0){
    1038:	fe0999e3          	bnez	s3,102a <vprintf+0x3e>
      if(c == '%'){
    103c:	ff4910e3          	bne	s2,s4,101c <vprintf+0x30>
        state = '%';
    1040:	89d2                	mv	s3,s4
    1042:	b7f5                	j	102e <vprintf+0x42>
      if(c == 'd'){
    1044:	13490463          	beq	s2,s4,116c <vprintf+0x180>
    1048:	f9d9079b          	addiw	a5,s2,-99
    104c:	0ff7f793          	zext.b	a5,a5
    1050:	12fb6763          	bltu	s6,a5,117e <vprintf+0x192>
    1054:	f9d9079b          	addiw	a5,s2,-99
    1058:	0ff7f713          	zext.b	a4,a5
    105c:	12eb6163          	bltu	s6,a4,117e <vprintf+0x192>
    1060:	00271793          	slli	a5,a4,0x2
    1064:	00000717          	auipc	a4,0x0
    1068:	5fc70713          	addi	a4,a4,1532 # 1660 <malloc+0x28c>
    106c:	97ba                	add	a5,a5,a4
    106e:	439c                	lw	a5,0(a5)
    1070:	97ba                	add	a5,a5,a4
    1072:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1074:	008b8913          	addi	s2,s7,8
    1078:	4685                	li	a3,1
    107a:	4629                	li	a2,10
    107c:	000ba583          	lw	a1,0(s7)
    1080:	8556                	mv	a0,s5
    1082:	00000097          	auipc	ra,0x0
    1086:	ebe080e7          	jalr	-322(ra) # f40 <printint>
    108a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    108c:	4981                	li	s3,0
    108e:	b745                	j	102e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1090:	008b8913          	addi	s2,s7,8
    1094:	4681                	li	a3,0
    1096:	4629                	li	a2,10
    1098:	000ba583          	lw	a1,0(s7)
    109c:	8556                	mv	a0,s5
    109e:	00000097          	auipc	ra,0x0
    10a2:	ea2080e7          	jalr	-350(ra) # f40 <printint>
    10a6:	8bca                	mv	s7,s2
      state = 0;
    10a8:	4981                	li	s3,0
    10aa:	b751                	j	102e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    10ac:	008b8913          	addi	s2,s7,8
    10b0:	4681                	li	a3,0
    10b2:	4641                	li	a2,16
    10b4:	000ba583          	lw	a1,0(s7)
    10b8:	8556                	mv	a0,s5
    10ba:	00000097          	auipc	ra,0x0
    10be:	e86080e7          	jalr	-378(ra) # f40 <printint>
    10c2:	8bca                	mv	s7,s2
      state = 0;
    10c4:	4981                	li	s3,0
    10c6:	b7a5                	j	102e <vprintf+0x42>
    10c8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    10ca:	008b8c13          	addi	s8,s7,8
    10ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    10d2:	03000593          	li	a1,48
    10d6:	8556                	mv	a0,s5
    10d8:	00000097          	auipc	ra,0x0
    10dc:	e46080e7          	jalr	-442(ra) # f1e <putc>
  putc(fd, 'x');
    10e0:	07800593          	li	a1,120
    10e4:	8556                	mv	a0,s5
    10e6:	00000097          	auipc	ra,0x0
    10ea:	e38080e7          	jalr	-456(ra) # f1e <putc>
    10ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10f0:	00000b97          	auipc	s7,0x0
    10f4:	5c8b8b93          	addi	s7,s7,1480 # 16b8 <digits>
    10f8:	03c9d793          	srli	a5,s3,0x3c
    10fc:	97de                	add	a5,a5,s7
    10fe:	0007c583          	lbu	a1,0(a5)
    1102:	8556                	mv	a0,s5
    1104:	00000097          	auipc	ra,0x0
    1108:	e1a080e7          	jalr	-486(ra) # f1e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    110c:	0992                	slli	s3,s3,0x4
    110e:	397d                	addiw	s2,s2,-1
    1110:	fe0914e3          	bnez	s2,10f8 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    1114:	8be2                	mv	s7,s8
      state = 0;
    1116:	4981                	li	s3,0
    1118:	6c02                	ld	s8,0(sp)
    111a:	bf11                	j	102e <vprintf+0x42>
        s = va_arg(ap, char*);
    111c:	008b8993          	addi	s3,s7,8
    1120:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    1124:	02090163          	beqz	s2,1146 <vprintf+0x15a>
        while(*s != 0){
    1128:	00094583          	lbu	a1,0(s2)
    112c:	c9a5                	beqz	a1,119c <vprintf+0x1b0>
          putc(fd, *s);
    112e:	8556                	mv	a0,s5
    1130:	00000097          	auipc	ra,0x0
    1134:	dee080e7          	jalr	-530(ra) # f1e <putc>
          s++;
    1138:	0905                	addi	s2,s2,1
        while(*s != 0){
    113a:	00094583          	lbu	a1,0(s2)
    113e:	f9e5                	bnez	a1,112e <vprintf+0x142>
        s = va_arg(ap, char*);
    1140:	8bce                	mv	s7,s3
      state = 0;
    1142:	4981                	li	s3,0
    1144:	b5ed                	j	102e <vprintf+0x42>
          s = "(null)";
    1146:	00000917          	auipc	s2,0x0
    114a:	4e290913          	addi	s2,s2,1250 # 1628 <malloc+0x254>
        while(*s != 0){
    114e:	02800593          	li	a1,40
    1152:	bff1                	j	112e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    1154:	008b8913          	addi	s2,s7,8
    1158:	000bc583          	lbu	a1,0(s7)
    115c:	8556                	mv	a0,s5
    115e:	00000097          	auipc	ra,0x0
    1162:	dc0080e7          	jalr	-576(ra) # f1e <putc>
    1166:	8bca                	mv	s7,s2
      state = 0;
    1168:	4981                	li	s3,0
    116a:	b5d1                	j	102e <vprintf+0x42>
        putc(fd, c);
    116c:	02500593          	li	a1,37
    1170:	8556                	mv	a0,s5
    1172:	00000097          	auipc	ra,0x0
    1176:	dac080e7          	jalr	-596(ra) # f1e <putc>
      state = 0;
    117a:	4981                	li	s3,0
    117c:	bd4d                	j	102e <vprintf+0x42>
        putc(fd, '%');
    117e:	02500593          	li	a1,37
    1182:	8556                	mv	a0,s5
    1184:	00000097          	auipc	ra,0x0
    1188:	d9a080e7          	jalr	-614(ra) # f1e <putc>
        putc(fd, c);
    118c:	85ca                	mv	a1,s2
    118e:	8556                	mv	a0,s5
    1190:	00000097          	auipc	ra,0x0
    1194:	d8e080e7          	jalr	-626(ra) # f1e <putc>
      state = 0;
    1198:	4981                	li	s3,0
    119a:	bd51                	j	102e <vprintf+0x42>
        s = va_arg(ap, char*);
    119c:	8bce                	mv	s7,s3
      state = 0;
    119e:	4981                	li	s3,0
    11a0:	b579                	j	102e <vprintf+0x42>
    11a2:	74e2                	ld	s1,56(sp)
    11a4:	79a2                	ld	s3,40(sp)
    11a6:	7a02                	ld	s4,32(sp)
    11a8:	6ae2                	ld	s5,24(sp)
    11aa:	6b42                	ld	s6,16(sp)
    11ac:	6ba2                	ld	s7,8(sp)
    }
  }
}
    11ae:	60a6                	ld	ra,72(sp)
    11b0:	6406                	ld	s0,64(sp)
    11b2:	7942                	ld	s2,48(sp)
    11b4:	6161                	addi	sp,sp,80
    11b6:	8082                	ret

00000000000011b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11b8:	715d                	addi	sp,sp,-80
    11ba:	ec06                	sd	ra,24(sp)
    11bc:	e822                	sd	s0,16(sp)
    11be:	1000                	addi	s0,sp,32
    11c0:	e010                	sd	a2,0(s0)
    11c2:	e414                	sd	a3,8(s0)
    11c4:	e818                	sd	a4,16(s0)
    11c6:	ec1c                	sd	a5,24(s0)
    11c8:	03043023          	sd	a6,32(s0)
    11cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11d4:	8622                	mv	a2,s0
    11d6:	00000097          	auipc	ra,0x0
    11da:	e16080e7          	jalr	-490(ra) # fec <vprintf>
}
    11de:	60e2                	ld	ra,24(sp)
    11e0:	6442                	ld	s0,16(sp)
    11e2:	6161                	addi	sp,sp,80
    11e4:	8082                	ret

00000000000011e6 <printf>:

void
printf(const char *fmt, ...)
{
    11e6:	7159                	addi	sp,sp,-112
    11e8:	f406                	sd	ra,40(sp)
    11ea:	f022                	sd	s0,32(sp)
    11ec:	ec26                	sd	s1,24(sp)
    11ee:	1800                	addi	s0,sp,48
    11f0:	84aa                	mv	s1,a0
    11f2:	e40c                	sd	a1,8(s0)
    11f4:	e810                	sd	a2,16(s0)
    11f6:	ec14                	sd	a3,24(s0)
    11f8:	f018                	sd	a4,32(s0)
    11fa:	f41c                	sd	a5,40(s0)
    11fc:	03043823          	sd	a6,48(s0)
    1200:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
    1204:	00000097          	auipc	ra,0x0
    1208:	d0a080e7          	jalr	-758(ra) # f0e <lock>
  va_start(ap, fmt);
    120c:	00840613          	addi	a2,s0,8
    1210:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
    1214:	85a6                	mv	a1,s1
    1216:	4505                	li	a0,1
    1218:	00000097          	auipc	ra,0x0
    121c:	dd4080e7          	jalr	-556(ra) # fec <vprintf>
  unlock();
    1220:	00000097          	auipc	ra,0x0
    1224:	cf6080e7          	jalr	-778(ra) # f16 <unlock>
}
    1228:	70a2                	ld	ra,40(sp)
    122a:	7402                	ld	s0,32(sp)
    122c:	64e2                	ld	s1,24(sp)
    122e:	6165                	addi	sp,sp,112
    1230:	8082                	ret

0000000000001232 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1232:	7179                	addi	sp,sp,-48
    1234:	f422                	sd	s0,40(sp)
    1236:	1800                	addi	s0,sp,48
    1238:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    123c:	fd843783          	ld	a5,-40(s0)
    1240:	17c1                	addi	a5,a5,-16
    1242:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1246:	00001797          	auipc	a5,0x1
    124a:	65a78793          	addi	a5,a5,1626 # 28a0 <freep>
    124e:	639c                	ld	a5,0(a5)
    1250:	fef43423          	sd	a5,-24(s0)
    1254:	a815                	j	1288 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1256:	fe843783          	ld	a5,-24(s0)
    125a:	639c                	ld	a5,0(a5)
    125c:	fe843703          	ld	a4,-24(s0)
    1260:	00f76f63          	bltu	a4,a5,127e <free+0x4c>
    1264:	fe043703          	ld	a4,-32(s0)
    1268:	fe843783          	ld	a5,-24(s0)
    126c:	02e7eb63          	bltu	a5,a4,12a2 <free+0x70>
    1270:	fe843783          	ld	a5,-24(s0)
    1274:	639c                	ld	a5,0(a5)
    1276:	fe043703          	ld	a4,-32(s0)
    127a:	02f76463          	bltu	a4,a5,12a2 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    127e:	fe843783          	ld	a5,-24(s0)
    1282:	639c                	ld	a5,0(a5)
    1284:	fef43423          	sd	a5,-24(s0)
    1288:	fe043703          	ld	a4,-32(s0)
    128c:	fe843783          	ld	a5,-24(s0)
    1290:	fce7f3e3          	bgeu	a5,a4,1256 <free+0x24>
    1294:	fe843783          	ld	a5,-24(s0)
    1298:	639c                	ld	a5,0(a5)
    129a:	fe043703          	ld	a4,-32(s0)
    129e:	faf77ce3          	bgeu	a4,a5,1256 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
    12a2:	fe043783          	ld	a5,-32(s0)
    12a6:	479c                	lw	a5,8(a5)
    12a8:	1782                	slli	a5,a5,0x20
    12aa:	9381                	srli	a5,a5,0x20
    12ac:	0792                	slli	a5,a5,0x4
    12ae:	fe043703          	ld	a4,-32(s0)
    12b2:	973e                	add	a4,a4,a5
    12b4:	fe843783          	ld	a5,-24(s0)
    12b8:	639c                	ld	a5,0(a5)
    12ba:	02f71763          	bne	a4,a5,12e8 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
    12be:	fe043783          	ld	a5,-32(s0)
    12c2:	4798                	lw	a4,8(a5)
    12c4:	fe843783          	ld	a5,-24(s0)
    12c8:	639c                	ld	a5,0(a5)
    12ca:	479c                	lw	a5,8(a5)
    12cc:	9fb9                	addw	a5,a5,a4
    12ce:	0007871b          	sext.w	a4,a5
    12d2:	fe043783          	ld	a5,-32(s0)
    12d6:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
    12d8:	fe843783          	ld	a5,-24(s0)
    12dc:	639c                	ld	a5,0(a5)
    12de:	6398                	ld	a4,0(a5)
    12e0:	fe043783          	ld	a5,-32(s0)
    12e4:	e398                	sd	a4,0(a5)
    12e6:	a039                	j	12f4 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
    12e8:	fe843783          	ld	a5,-24(s0)
    12ec:	6398                	ld	a4,0(a5)
    12ee:	fe043783          	ld	a5,-32(s0)
    12f2:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
    12f4:	fe843783          	ld	a5,-24(s0)
    12f8:	479c                	lw	a5,8(a5)
    12fa:	1782                	slli	a5,a5,0x20
    12fc:	9381                	srli	a5,a5,0x20
    12fe:	0792                	slli	a5,a5,0x4
    1300:	fe843703          	ld	a4,-24(s0)
    1304:	97ba                	add	a5,a5,a4
    1306:	fe043703          	ld	a4,-32(s0)
    130a:	02f71563          	bne	a4,a5,1334 <free+0x102>
    p->s.size += bp->s.size;
    130e:	fe843783          	ld	a5,-24(s0)
    1312:	4798                	lw	a4,8(a5)
    1314:	fe043783          	ld	a5,-32(s0)
    1318:	479c                	lw	a5,8(a5)
    131a:	9fb9                	addw	a5,a5,a4
    131c:	0007871b          	sext.w	a4,a5
    1320:	fe843783          	ld	a5,-24(s0)
    1324:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1326:	fe043783          	ld	a5,-32(s0)
    132a:	6398                	ld	a4,0(a5)
    132c:	fe843783          	ld	a5,-24(s0)
    1330:	e398                	sd	a4,0(a5)
    1332:	a031                	j	133e <free+0x10c>
  } else
    p->s.ptr = bp;
    1334:	fe843783          	ld	a5,-24(s0)
    1338:	fe043703          	ld	a4,-32(s0)
    133c:	e398                	sd	a4,0(a5)
  freep = p;
    133e:	00001797          	auipc	a5,0x1
    1342:	56278793          	addi	a5,a5,1378 # 28a0 <freep>
    1346:	fe843703          	ld	a4,-24(s0)
    134a:	e398                	sd	a4,0(a5)
}
    134c:	0001                	nop
    134e:	7422                	ld	s0,40(sp)
    1350:	6145                	addi	sp,sp,48
    1352:	8082                	ret

0000000000001354 <morecore>:

static Header*
morecore(uint nu)
{
    1354:	7179                	addi	sp,sp,-48
    1356:	f406                	sd	ra,40(sp)
    1358:	f022                	sd	s0,32(sp)
    135a:	1800                	addi	s0,sp,48
    135c:	87aa                	mv	a5,a0
    135e:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
    1362:	fdc42783          	lw	a5,-36(s0)
    1366:	0007871b          	sext.w	a4,a5
    136a:	6785                	lui	a5,0x1
    136c:	00f77563          	bgeu	a4,a5,1376 <morecore+0x22>
    nu = 4096;
    1370:	6785                	lui	a5,0x1
    1372:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
    1376:	fdc42783          	lw	a5,-36(s0)
    137a:	0047979b          	slliw	a5,a5,0x4
    137e:	2781                	sext.w	a5,a5
    1380:	2781                	sext.w	a5,a5
    1382:	853e                	mv	a0,a5
    1384:	00000097          	auipc	ra,0x0
    1388:	b6a080e7          	jalr	-1174(ra) # eee <sbrk>
    138c:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
    1390:	fe843703          	ld	a4,-24(s0)
    1394:	57fd                	li	a5,-1
    1396:	00f71463          	bne	a4,a5,139e <morecore+0x4a>
    return 0;
    139a:	4781                	li	a5,0
    139c:	a03d                	j	13ca <morecore+0x76>
  hp = (Header*)p;
    139e:	fe843783          	ld	a5,-24(s0)
    13a2:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
    13a6:	fe043783          	ld	a5,-32(s0)
    13aa:	fdc42703          	lw	a4,-36(s0)
    13ae:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
    13b0:	fe043783          	ld	a5,-32(s0)
    13b4:	07c1                	addi	a5,a5,16 # 1010 <vprintf+0x24>
    13b6:	853e                	mv	a0,a5
    13b8:	00000097          	auipc	ra,0x0
    13bc:	e7a080e7          	jalr	-390(ra) # 1232 <free>
  return freep;
    13c0:	00001797          	auipc	a5,0x1
    13c4:	4e078793          	addi	a5,a5,1248 # 28a0 <freep>
    13c8:	639c                	ld	a5,0(a5)
}
    13ca:	853e                	mv	a0,a5
    13cc:	70a2                	ld	ra,40(sp)
    13ce:	7402                	ld	s0,32(sp)
    13d0:	6145                	addi	sp,sp,48
    13d2:	8082                	ret

00000000000013d4 <malloc>:

void*
malloc(uint nbytes)
{
    13d4:	7139                	addi	sp,sp,-64
    13d6:	fc06                	sd	ra,56(sp)
    13d8:	f822                	sd	s0,48(sp)
    13da:	0080                	addi	s0,sp,64
    13dc:	87aa                	mv	a5,a0
    13de:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13e2:	fcc46783          	lwu	a5,-52(s0)
    13e6:	07bd                	addi	a5,a5,15
    13e8:	8391                	srli	a5,a5,0x4
    13ea:	2781                	sext.w	a5,a5
    13ec:	2785                	addiw	a5,a5,1
    13ee:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
    13f2:	00001797          	auipc	a5,0x1
    13f6:	4ae78793          	addi	a5,a5,1198 # 28a0 <freep>
    13fa:	639c                	ld	a5,0(a5)
    13fc:	fef43023          	sd	a5,-32(s0)
    1400:	fe043783          	ld	a5,-32(s0)
    1404:	ef95                	bnez	a5,1440 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
    1406:	00001797          	auipc	a5,0x1
    140a:	48a78793          	addi	a5,a5,1162 # 2890 <base>
    140e:	fef43023          	sd	a5,-32(s0)
    1412:	00001797          	auipc	a5,0x1
    1416:	48e78793          	addi	a5,a5,1166 # 28a0 <freep>
    141a:	fe043703          	ld	a4,-32(s0)
    141e:	e398                	sd	a4,0(a5)
    1420:	00001797          	auipc	a5,0x1
    1424:	48078793          	addi	a5,a5,1152 # 28a0 <freep>
    1428:	6398                	ld	a4,0(a5)
    142a:	00001797          	auipc	a5,0x1
    142e:	46678793          	addi	a5,a5,1126 # 2890 <base>
    1432:	e398                	sd	a4,0(a5)
    base.s.size = 0;
    1434:	00001797          	auipc	a5,0x1
    1438:	45c78793          	addi	a5,a5,1116 # 2890 <base>
    143c:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1440:	fe043783          	ld	a5,-32(s0)
    1444:	639c                	ld	a5,0(a5)
    1446:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    144a:	fe843783          	ld	a5,-24(s0)
    144e:	4798                	lw	a4,8(a5)
    1450:	fdc42783          	lw	a5,-36(s0)
    1454:	2781                	sext.w	a5,a5
    1456:	06f76763          	bltu	a4,a5,14c4 <malloc+0xf0>
      if(p->s.size == nunits)
    145a:	fe843783          	ld	a5,-24(s0)
    145e:	4798                	lw	a4,8(a5)
    1460:	fdc42783          	lw	a5,-36(s0)
    1464:	2781                	sext.w	a5,a5
    1466:	00e79963          	bne	a5,a4,1478 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    146a:	fe843783          	ld	a5,-24(s0)
    146e:	6398                	ld	a4,0(a5)
    1470:	fe043783          	ld	a5,-32(s0)
    1474:	e398                	sd	a4,0(a5)
    1476:	a825                	j	14ae <malloc+0xda>
      else {
        p->s.size -= nunits;
    1478:	fe843783          	ld	a5,-24(s0)
    147c:	479c                	lw	a5,8(a5)
    147e:	fdc42703          	lw	a4,-36(s0)
    1482:	9f99                	subw	a5,a5,a4
    1484:	0007871b          	sext.w	a4,a5
    1488:	fe843783          	ld	a5,-24(s0)
    148c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    148e:	fe843783          	ld	a5,-24(s0)
    1492:	479c                	lw	a5,8(a5)
    1494:	1782                	slli	a5,a5,0x20
    1496:	9381                	srli	a5,a5,0x20
    1498:	0792                	slli	a5,a5,0x4
    149a:	fe843703          	ld	a4,-24(s0)
    149e:	97ba                	add	a5,a5,a4
    14a0:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    14a4:	fe843783          	ld	a5,-24(s0)
    14a8:	fdc42703          	lw	a4,-36(s0)
    14ac:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    14ae:	00001797          	auipc	a5,0x1
    14b2:	3f278793          	addi	a5,a5,1010 # 28a0 <freep>
    14b6:	fe043703          	ld	a4,-32(s0)
    14ba:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    14bc:	fe843783          	ld	a5,-24(s0)
    14c0:	07c1                	addi	a5,a5,16
    14c2:	a091                	j	1506 <malloc+0x132>
    }
    if(p == freep)
    14c4:	00001797          	auipc	a5,0x1
    14c8:	3dc78793          	addi	a5,a5,988 # 28a0 <freep>
    14cc:	639c                	ld	a5,0(a5)
    14ce:	fe843703          	ld	a4,-24(s0)
    14d2:	02f71063          	bne	a4,a5,14f2 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    14d6:	fdc42783          	lw	a5,-36(s0)
    14da:	853e                	mv	a0,a5
    14dc:	00000097          	auipc	ra,0x0
    14e0:	e78080e7          	jalr	-392(ra) # 1354 <morecore>
    14e4:	fea43423          	sd	a0,-24(s0)
    14e8:	fe843783          	ld	a5,-24(s0)
    14ec:	e399                	bnez	a5,14f2 <malloc+0x11e>
        return 0;
    14ee:	4781                	li	a5,0
    14f0:	a819                	j	1506 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14f2:	fe843783          	ld	a5,-24(s0)
    14f6:	fef43023          	sd	a5,-32(s0)
    14fa:	fe843783          	ld	a5,-24(s0)
    14fe:	639c                	ld	a5,0(a5)
    1500:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1504:	b799                	j	144a <malloc+0x76>
  }
}
    1506:	853e                	mv	a0,a5
    1508:	70e2                	ld	ra,56(sp)
    150a:	7442                	ld	s0,48(sp)
    150c:	6121                	addi	sp,sp,64
    150e:	8082                	ret
