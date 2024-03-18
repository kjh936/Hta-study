DROP TABLE board CASCADE CONSTRAINTS purge;

CREATE TABLE board
(
    board_num       NUMBER, -- 글 번호
    board_name      VARCHAR2(30), -- 작성자
    board_pass      VARCHAR2(30), -- 비밀번호
    board_subject   VARCHAR2(30), -- 제목
    board_contetn   VARCHAR2(30), -- 내용
    board_file      VARCHAR2(30), -- 첨부할 파일
    board_re_ref    NUMBER, -- 답변 글 작성시 참조
    board_re_lev    NUMBER, -- 답변 글의 길이
    board_re_seq    NUMBER, -- 답변 글의 순서
    board_readcount NUMBER, -- 글의 조회수
    boar_date       DATE DEFAULT SYSDATE,
    PRIMARY KEY (board_num)
);

SELECT * FROM comm;
SELECT * FROM board;

INSERT INTO board (board_num, board_subject, board_name, board_re_ref)
VALUES (1, '처음', 'admin', 1);
INSERT INTO board (board_num, board_subject, board_name, board_re_ref)
VALUES (2, '둘째', 'admin', 2);
INSERT INTO board (board_num, board_subject, board_name, board_re_ref)
VALUES (3, '셋째', 'admin', 3);

INSERT INTO comm (num, id, COMMENT_BOARD_NUM) VALUES (1,'admin',1);
INSERT INTO comm (num, id, COMMENT_BOARD_NUM) VALUES (2,'admin',1);
INSERT INTO comm (num, id, COMMENT_BOARD_NUM) VALUES (3,'admin',2);
INSERT INTO comm (num, id, COMMENT_BOARD_NUM) VALUES (4,'admin',2);

UPDATE board
SET board_subject = '오늘도 행복하세요'
WHERE board_num = 1;

SELECT COMMENT_BOARD_NUM, COUNT(num) AS CNT
FROM comm
GROUP BY COMMENT_BOARD_NUM;

SELECT board_num, board_subject, CNT
FROM board, (SELECT COMMENT_BOARD_NUM, COUNT(num) AS CNT
             FROM comm
             GROUP BY COMMENT_BOARD_NUM)
WHERE board_num = comment_board_num;

-- OUTER JOIN을 이용해서 board의 글이 모두 표시되고 cnt가 null인 경우 0으로 표시하도록 합니다.
-- 1단계)
SELECT board_num, board_subject, CNT
FROM board, (SELECT COMMENT_BOARD_NUM, COUNT(num) AS CNT
             FROM comm
             GROUP BY COMMENT_BOARD_NUM)
WHERE board_num = comment_board_num(+);

-- 2단계)
SELECT board_num, board_subject, NVL(CNT, 0)
FROM board, (SELECT COMMENT_BOARD_NUM, COUNT(num) AS CNT
             FROM comm
             GROUP BY COMMENT_BOARD_NUM)
WHERE board_num = comment_board_num(+)
ORDER BY board_re_ref DESC , board_re_ref;

DELETE board;
SELECT * FROM board;
SELECT * FROM comm;

SELECT *
FROM (SELECT ROWNUM rnum, j.*
      FROM (SELECT board.*, NVL(CNT, 0)
            FROM board, (SELECT COMMENT_BOARD_NUM, COUNT(num) AS CNT
                         FROM comm
                         GROUP BY COMMENT_BOARD_NUM)
            WHERE board_num = comment_board_num(+)
            ORDER BY board_re_ref DESC , board_re_ref) j
      WHERE ROWNUM <= 30
      )
WHERE rnum >= 3 AND rnum <= 6;
