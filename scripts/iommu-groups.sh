#!/usr/bin/env bash
# This is a slightly modified version of the script found at 
#    https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Ensuring_that_the_groups_are_valid
# It adds a tab to make the output prettier and sorts the output per-group
shopt -s nullglob;
for d in /sys/kernel/iommu_groups/*/devices/*;
do
        n="${d#*/iommu_groups/*}";
        n="${n%%/*}";
        printf 'IOMMU Group %s \t' "$n";
        lspci -nns "${d##*/}";
done | sort -h -k 3

