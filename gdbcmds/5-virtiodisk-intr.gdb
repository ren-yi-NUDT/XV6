#virtio_disk_intr():
break virtio_disk.c:321
  commands
    printf "*disk.used: "
    p *disk.used
    printf "disk.used_idx: %d\n", disk.used_idx
    printf "disk.ops[%d]: ", disk.used->ring[disk.used_idx].id
    p disk.ops[disk.used->ring[disk.used_idx].id]
    printf "disk.info[%d]: ", disk.used->ring[disk.used_idx].id
    p disk.info[disk.used->ring[disk.used_idx].id]
  end
