package in.java.project;

import java.sql.Timestamp;

public class StockHistoryRecord {
    private Timestamp date;
    private int quantityChange;

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    public int getQuantityChange() {
        return quantityChange;
    }

    public void setQuantityChange(int quantityChange) {
        this.quantityChange = quantityChange;
    }
}