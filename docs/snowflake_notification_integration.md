# Snowflake Notification Integration

```sql
CREATE OR REPLACE NOTIFICATION INTEGRATION my_email_int
  TYPE=EMAIL
  ENABLED=TRUE
  ALLOWED_RECIPIENTS = ('filipe_balseiro@hakkoda.io');
```