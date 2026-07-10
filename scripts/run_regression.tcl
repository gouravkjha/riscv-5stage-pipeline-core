# ============================================================================
# RISC-V Automated Regression Script (Silent Clean Execution Version)
# ============================================================================

proc run_riscv_regression {} {
    set test_suites {
        rv32ui-p-add     rv32ui-p-addi    rv32ui-p-and     rv32ui-p-andi
        rv32ui-p-auipc   rv32ui-p-beq     rv32ui-p-bge     rv32ui-p-bgeu
        rv32ui-p-blt     rv32ui-p-bltu    rv32ui-p-bne     rv32ui-p-jal
        rv32ui-p-jalr    rv32ui-p-lb      rv32ui-p-lbu     rv32ui-p-ld_st
        rv32ui-p-lh      rv32ui-p-lhu     rv32ui-p-lui     rv32ui-p-lw
        rv32ui-p-ma_data rv32ui-p-or      rv32ui-p-ori     rv32ui-p-sb
        rv32ui-p-sh      rv32ui-p-simple  rv32ui-p-sll     rv32ui-p-slli
        rv32ui-p-slt     rv32ui-p-slti    rv32ui-p-sltiu   rv32ui-p-sltu
        rv32ui-p-sra     rv32ui-p-srai    rv32ui-p-srl     rv32ui-p-srli
        rv32ui-p-st_ld   rv32ui-p-sub     rv32ui-p-sw      rv32ui-p-xor
        rv32ui-p-xori
    }

    set passed 0
    set failed 0
    set total [llength $test_suites]

    set proj_name [current_project]
    set proj_dir  [get_property DIRECTORY [current_project]]

    set status_file  "$proj_dir/$proj_name.sim/sim_1/behav/xsim/status.txt"
    set hex_base_dir "$proj_dir/tests_hex"

    puts "===================================================="
    puts "RISC-V 41-TEST REGRESSION ENVIRONMENT LAUNCHED"
    puts "===================================================="

    foreach test $test_suites {
        close_sim -quiet

        if {[file exists $status_file]} {
            catch {file delete -force $status_file}
        }

        puts -nonewline [format "Running %-25s ... " $test]
        flush stdout

        set_property generic "MEM_FILE=\"$hex_base_dir/$test.mem\"" [current_fileset -simset]
        
        if {[catch {launch_simulation -quiet} msg]} {
            puts "CRASH (Launch failed)"
            incr failed
            continue
        }
        
        run all
        close_sim -quiet

        if {![file exists $status_file]} {
            puts "FAIL (Simulation hung / No Handshake Token)"
            incr failed
            continue
        }

        set fp [open $status_file r]
        set status_data [read $fp]
        close $fp

        if {[regexp {PASSED} $status_data]} {
            incr passed
            puts "PASS"
        } elseif {[regexp {CRASH} $status_data]} {
            incr failed
            puts "FAIL (Hardware Crash / PC Boundary Violation)"
        } elseif {[regexp {FAILED_(\d+)} $status_data match subtest]} {
            incr failed
            puts "FAIL (Subtest $subtest)"
        } else {
            incr failed
            puts "TIMEOUT"
        }
    }

    puts ""
    puts "===================================================="
    puts "True Regression Scorecard Summary"
    puts "===================================================="
    puts "Total Tests Executed : $total"
    puts "Passed Vectors       : $passed"
    puts "Failed Vectors       : $failed"
    puts "Functional Accuracy  : [format "%.2f" [expr (double($passed)/$total)*100]]%"
    puts "===================================================="
}

run_riscv_regression