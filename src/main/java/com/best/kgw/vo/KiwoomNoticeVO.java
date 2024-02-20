package com.best.kgw.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class KiwoomNoticeVO {
    private int board_no;
    private int emp_no;
    private String board_title;
    private String board_content;
    private String reg_date;
    private int board_hit;
    private String mod_date;

    @Override
    public String toString() {
        return "KiwoomNoticeVO{" +
                "board_no=" + board_no +
                ", emp_no=" + emp_no +
                ", board_title='" + board_title + '\'' +
                ", board_content='" + board_content + '\'' +
                ", reg_date='" + reg_date + '\'' +
                ", board_hit=" + board_hit +
                ", mod_date='" + mod_date + '\'' +
                '}';
    }
}