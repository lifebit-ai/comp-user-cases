process count_reads {
  input:
  tuple val(sample_id), path(read1), path(read2)

  output:
  path("*.txt"), emit: output1

  script:
  """
  grep -c ">" $read1 >> ${sample_id}_readcount.txt
  grep -c ">" $read2 >> ${sample_id}_readcount.txt
  pivot_variant.py --test value
  """
}


process report_read_count {
  input:
  path read_count

  output:
  path "*.csv"

  script:
  """
  for fl in $read_count;
  do cat \$fl >> report.csv;
  done;

  touch $params.test_file
  """

}

workflow read_count {
  take: data
  main:
    count_reads(data)
    report_read_count(count_reads.out.output1.collect())
  emit:
    report_read_count.out
}
