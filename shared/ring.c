/* SPDX-License-Identifier: GPL-2.0 or MIT */
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/mod_devicetable.h>
#include <linux/types.h>
#include <linux/io.h>
#include <linux/mutex.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/kernel.h>
#include <linux/uaccess.h>
#include "fp_conversions.h"

#define LEFT_ENABLE_OFFSET 0x0
#define LEFT_ALPHA_OFFSET 0x4
// todo: define left Volume offset
#define LEFT_VOLUME_OFFSET 0x8
#define RIGHT_ENABLE_OFFSET 0x10
#define RIGHT_ALPHA_OFFSET 0x14
// todo: define right Volume offset 
#define RIGHT_VOLUME_OFFSET 0x18

#define VOLUME_FBITS 7
#define VOLUME_IS_SIGNED 0

#define SPAN 0x20

struct ring_dev {
	struct miscdevice miscdev;
	void __iomem *base_addr;
	struct mutex lock;
};

static ssize_t left_enable_show(struct device *dev,
	struct device_attribute *attr, char *buf)
{
	bool left_enable;
	struct ring_dev *priv = dev_get_drvdata(dev);

	left_enable = ioread32(priv->base_addr + LEFT_ENABLE_OFFSET);

	return scnprintf(buf, PAGE_SIZE, "%u\n", left_enable);
}

static ssize_t left_enable_store(struct device *dev,
	struct device_attribute *attr, const char *buf, size_t size)
{
	bool left_enable;
	int ret;
	struct ring_dev *priv = dev_get_drvdata(dev);

	// Parse the string we received as a bool
	ret = kstrtobool(buf, &left_enable);
	if (ret < 0) {
		// kstrtobool returned an error
		return ret;
	}

	iowrite32(left_enable, priv->base_addr + LEFT_ENABLE_OFFSET);
	return size;
}

static ssize_t right_enable_show(struct device *dev,
	struct device_attribute *attr, char *buf)
{
	bool right_enable;
	struct ring_dev *priv = dev_get_drvdata(dev);

	right_enable = ioread32(priv->base_addr + RIGHT_ENABLE_OFFSET);

	return scnprintf(buf, PAGE_SIZE, "%u\n", right_enable);
}

static ssize_t right_enable_store(struct device *dev,
	struct device_attribute *attr, const char *buf, size_t size)
{
	bool right_enable;
	int ret;
	struct ring_dev *priv = dev_get_drvdata(dev);

	// Parse the string we received as a bool
	ret = kstrtobool(buf, &right_enable);
	if (ret < 0) {
		// kstrtobool returned an error
		return ret;
	}

	iowrite32(right_enable, priv->base_addr + RIGHT_ENABLE_OFFSET);

	// Write was succesful, so we return the number of bytes we wrote.
	return size;
}

static ssize_t left_Alpha_show(struct device *dev,
	struct device_attribute *attr, char *buf)
{
	u16 left_Alpha;
	struct ring_dev *priv = dev_get_drvdata(dev);

	left_Alpha = ioread32(priv->base_addr + LEFT_ALPHA_OFFSET);

	return scnprintf(buf, PAGE_SIZE, "%u\n", left_Alpha);
}

static ssize_t left_Alpha_store(struct device *dev,
	struct device_attribute *attr, const char *buf, size_t size)
{
	u16 left_Alpha;
	int ret;
	struct ring_dev *priv = dev_get_drvdata(dev);

	// Parse the string we received as a u16
	ret = kstrtou16(buf, 0, &left_Alpha);
	if (ret < 0) {
		// kstrtou16 returned an error
		return ret;
	}

	iowrite32(left_Alpha, priv->base_addr + LEFT_ALPHA_OFFSET);

	// Write was succesful, so we return the number of bytes we wrote.
	return size;
}

static ssize_t right_Alpha_show(struct device *dev,
	struct device_attribute *attr, char *buf)
{
	u16 right_Alpha;
	struct ring_dev *priv = dev_get_drvdata(dev);

	right_Alpha = ioread32(priv->base_addr + RIGHT_ALPHA_OFFSET);

	return scnprintf(buf, PAGE_SIZE, "%u\n", right_Alpha);
}

static ssize_t right_Alpha_store(struct device *dev,
	struct device_attribute *attr, const char *buf, size_t size)
{
	u16 right_Alpha;
	int ret;
	struct ring_dev *priv = dev_get_drvdata(dev);

	// Parse the string we received as a u16
	ret = kstrtou16(buf, 0, &right_Alpha);
	if (ret < 0) {
		// kstrtou16 returned an error
		return ret;
	}

	iowrite32(right_Alpha, priv->base_addr + RIGHT_ALPHA_OFFSET);

	// Write was succesful, so we return the number of bytes we wrote.
	return size;
}

static ssize_t left_Volume_show(struct device *dev,
	struct device_attribute *attr, char *buf)
{
	u32 left_Volume;
	struct ring_dev *priv = dev_get_drvdata(dev);

	left_Volume = ioread32(priv->base_addr + LEFT_VOLUME_OFFSET);

	return fp_to_str(buf, left_Volume, VOLUME_FBITS, VOLUME_IS_SIGNED);

// todo: Add left_Volume_show() code
// Use  1.) dev_get_drvdata()
//      2.) ioread32()
//      3.) fp_to_str()
}

static ssize_t left_Volume_store(struct device *dev,
	struct device_attribute *attr, const char *buf, size_t size)
{
	u32 left_Volume;
	int ret;
	struct ring_dev *priv = dev_get_drvdata(dev);

	// Parse the string we received as a u16
	left_Volume = str_to_fp(buf, VOLUME_FBITS, VOLUME_IS_SIGNED, size);
	iowrite32(left_Volume, priv->base_addr + LEFT_VOLUME_OFFSET);

	// Write was succesful, so we return the number of bytes we wrote.
	return size;

// todo: Add left_Volume_store() code
// Use  1.) dev_get_drvdata()
//      2.) str_to_fp()
//      3.) iowrite32()
}

static ssize_t right_Volume_show(struct device *dev,
	struct device_attribute *attr, char *buf)
{
	u32 right_Volume;
	struct ring_dev *priv = dev_get_drvdata(dev);

	right_Volume = ioread32(priv->base_addr + RIGHT_VOLUME_OFFSET);

	return fp_to_str(buf, right_Volume, VOLUME_FBITS, VOLUME_IS_SIGNED);

// todo: Add right_Volume_show() code
// Use  1.) dev_get_drvdata()
//      2.) ioread32()
//      3.) fp_to_str()
}

static ssize_t right_Volume_store(struct device *dev,
	struct device_attribute *attr, const char *buf, size_t size)
{
	u32 right_Volume;
	int ret;
	struct ring_dev *priv = dev_get_drvdata(dev);

	// Parse the string we received as a u16
	right_Volume = str_to_fp(buf, VOLUME_FBITS, VOLUME_IS_SIGNED, size);
	iowrite32(right_Volume, priv->base_addr + RIGHT_VOLUME_OFFSET);

	// Write was succesful, so we return the number of bytes we wrote.
	return size;
// todo: Add right_Volume_store() code
// Use  1.) dev_get_drvdata()
//      2.) str_to_fp()
//      3.) iowrite32()
}

// Define sysfs attributes
static DEVICE_ATTR_RW(left_enable);
static DEVICE_ATTR_RW(right_enable);
static DEVICE_ATTR_RW(left_Volume);
static DEVICE_ATTR_RW(right_Volume);
// todo: define left Volume attribute 
// todo: define right Volume attribute
static DEVICE_ATTR_RW(left_Alpha);
static DEVICE_ATTR_RW(right_Alpha);

// Create an atribute group so the device core can export the attributes for us.
static struct attribute *ring_attrs[] = {
	&dev_attr_left_enable.attr,
	&dev_attr_right_enable.attr,
	&dev_attr_left_Volume.attr,
	&dev_attr_right_Volume.attr,
// todo: add left Volume attribute 
// todo: add right Volume attribute 
	&dev_attr_left_Alpha.attr,
	&dev_attr_right_Alpha.attr,
	NULL,
};
ATTRIBUTE_GROUPS(ring);

static ssize_t ring_read(struct file *file, char __user *buf,
	size_t count, loff_t *offset)
{
	size_t ret;
	u32 val;

	loff_t pos = *offset;

	struct ring_dev *priv = container_of(file->private_data,
	                                     struct ring_dev,
					     miscdev);


	// Check file offset to make sure we are reading to a valid location.
	if (pos < 0) {
		// We can't read from a negative file position.
		return -EINVAL;
	}
	if (pos >= SPAN) {
		// We can't read from a position past the end of our device.
		return 0;
	}
	if ((pos % 0x4) != 0) {
		pr_warn("ring_read: unaligned access\n");
		return -EFAULT;
	}

	// If the user didn't request any bytes, don't return any bytes :)
	if (count == 0) {
		return 0;
	}

	// Read the value at offset pos.
	val = ioread32(priv->base_addr + pos);

	ret = copy_to_user(buf, &val, sizeof(val));
	if (ret == sizeof(val)) {
		// Nothing was copied to the user.
		pr_warn("ring_read: nothing copied\n");
		return -EFAULT;
	}

	// Increment the file offset by the number of bytes we read.
	*offset = pos + sizeof(val);

	return sizeof(val);
}

static ssize_t ring_write(struct file *file, const char __user *buf,
	size_t count, loff_t *offset)
{
	size_t ret;
	u32 val;

	loff_t pos = *offset;

	struct ring_dev *priv = container_of(file->private_data,
	                                     struct ring_dev,
					     miscdev);


	// Check file offset to make sure we are writing to a valid location.
	if (pos < 0) {
		// We can't write to a negative file position.
		return -EINVAL;
	}
	if (pos >= SPAN) {
		// We can't write to a position past the end of our device.
		return 0;
	}
	if ((pos % 0x4) != 0) {
		
		pr_warn("ring_write: unaligned access\n");
		return -EFAULT;
	}

	// If the user didn't request to write anything, return 0.
	if (count == 0) {
		return 0;
	}

	mutex_lock(&priv->lock);

	ret = copy_from_user(&val, buf, sizeof(val));
	if (ret == sizeof(val)) {
		// Nothing was copied from the user.
		pr_warn("ring_write: nothing copied\n");
		ret = -EFAULT;
		goto unlock;
	}

	// Write the value we were given at the address offset given by pos.
	iowrite32(val, priv->base_addr + pos);

	// Increment the file offset by the number of bytes we wrote.
	*offset = pos + sizeof(val);

	// Return the number of bytes we wrote.
	ret = sizeof(val);

unlock:
	mutex_unlock(&priv->lock);
	return ret;
}

static const struct file_operations ring_fops = {
	.owner = THIS_MODULE,
	.read = ring_read,
	.write = ring_write,
	.llseek = default_llseek,
};

static int ring_probe(struct platform_device *pdev)
{
	struct ring_dev *priv;
	int ret;

	priv = devm_kzalloc(&pdev->dev, sizeof(struct ring_dev), GFP_KERNEL);
	if (!priv) {
		pr_err("Failed to allocate memory\n");
		return -ENOMEM;
	}

	priv->base_addr = devm_platform_ioremap_resource(pdev, 0);
	if (IS_ERR(priv->base_addr)) {
		pr_err("Failed to request/remap platform device resource\n");
		return PTR_ERR(priv->base_addr);
	}

	// Initialize the misc device parameters
	priv->miscdev.minor = MISC_DYNAMIC_MINOR;
	priv->miscdev.name = "ring";
	priv->miscdev.fops = &ring_fops;
	priv->miscdev.parent = &pdev->dev;
	priv->miscdev.groups = ring_groups;

	// Register the misc device; this creates a char dev at /dev/ring
	ret = misc_register(&priv->miscdev);
	if (ret) {
		pr_err("Failed to register misc device");
		return ret;
	}

	// Attach the ring's private data to the platform device's struct.
	platform_set_drvdata(pdev, priv);

	pr_info("ring_probe successful\n");

	return 0;
}

static int ring_remove(struct platform_device *pdev)
{
	// Get the ring's private data from the platform device.
	struct ring_dev *priv = platform_get_drvdata(pdev);

	// Deregister the misc device and remove the /dev/ring file.
	misc_deregister(&priv->miscdev);

	pr_info("ring_remove successful\n");

	return 0;
}

static const struct of_device_id ring_of_match[] = {
	{ .compatible = "Wulfing,ring", },
    // todo: Add compatible string with your lastname
	{ }
};
MODULE_DEVICE_TABLE(of, ring_of_match);

static struct platform_driver ring_driver = {
	.probe = ring_probe,
	.remove = ring_remove,
	.driver = {
		.owner = THIS_MODULE,
		.name = "ring",
		.of_match_table = ring_of_match,
		.dev_groups = ring_groups,
	},
};

/*
 * We don't need to do anything special in module init/exit.
 * This macro automatically handles module init/exit.
 */
module_platform_driver(ring_driver);

MODULE_LICENSE("Dual MIT/GPL");
// todo: Add MODULE_AUTHOR("with your name");
MODULE_AUTHOR("Adam Wulfing");
MODULE_DESCRIPTION("ring driver");
MODULE_VERSION("1.0");
