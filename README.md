# Basic filters for image restitution

When acquiring an image, several disturbances can be introduced by the imaging system, the acquisition chain or the surrounding noise. 

The file `main.m` explores and develops basic filtering methods that allow us to reconstruct an image as faithfully as possible:
- inverse filter
- Wiener filter

Windows are in `data/windows.mat`.

Images that we will work with are in `data`:

![](images/images.jpg)


## Part 1

First we observe the windows that will be applied on the Palaiseau image in order to simulate disturbances.

Point spread function (PSF):

![](images/psf.jpg)

PSF Fourier:

![](images/fft_psf.jpg)

Rectangle (Rect):

![](images/rect.jpg)

Rect Fourier:

![](images/fft_rect.jpg)

Fourier tranform cuts at zero frequency:

![](images/ft_cuts.jpg)


Let's take a look at the effect these disturbances have on the images. `y0` represents the disturbed image without additional noise, `yb` represents the disturbed image with additive white gaussian noise.

![](images/disturbances.jpg)


The first filter we will study is the most basic one, the inverse filter. Naturally this filter does not work when there is additional noise, as it amplifies it:

![](images/inverse_filter.jpg)


The second filter is the Wiener filter, which works well even in the presence of additional noise:

![](images/wiener_filter.jpg)


## Part 2

Application of the Wiener filter for camera shake.

![](images/camera_shake.jpg)