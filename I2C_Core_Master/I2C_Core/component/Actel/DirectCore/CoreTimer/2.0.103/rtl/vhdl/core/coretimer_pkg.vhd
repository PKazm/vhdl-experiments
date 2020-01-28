
-- ********************************************************************/ 
-- Microsemi Corporation Proprietary and Confidential
-- Copyright 2015 Microsemi Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN 
-- ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED 
-- IN ADVANCE IN WRITING.  
--  
--
-- CoreTimer Package
--
--
-- SVN Revision Information:
-- SVN $Revision: 23983 $
-- SVN $Date: 2014-11-28 10:12:46 -0800 (Fri, 28 Nov 2014) $
--
-- Resolved SARs
-- SAR      Date     Who   Description
--
-- Notes: 
--
-- *********************************************************************/ 
package coretimer_pkg is
function SYNC_MODE_SEL(FAMILY: INTEGER) return INTEGER;
end coretimer_pkg;

package body coretimer_pkg is 
    FUNCTION SYNC_MODE_SEL (FAMILY: INTEGER) RETURN INTEGER IS
        VARIABLE return_val : INTEGER := 0;
        BEGIN
        IF(FAMILY = 25) THEN
            return_val := 1;
        ELSE
            return_val := 0;
        END IF;
        RETURN return_val;
    END SYNC_MODE_SEL;
end coretimer_pkg;