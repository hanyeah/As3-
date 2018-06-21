package com.hanyeah.math{
	
	/**
	 * 复变函数类.
	 */
	public class HComplex{
		public var re:Number;
		public var im:Number;
		public static const EPSILON:Number = 1e-16;
		public static const ZERO:HComplex = new HComplex(0, 0);
		public static const ONE:HComplex = new HComplex(1, 0);
		public static const I:HComplex = new HComplex(0, 1);
		public static const PI:HComplex = new HComplex(Math.PI, 0);
		public static const E:HComplex = new HComplex(Math.E, 0);
		public static const INFINITY:HComplex = new HComplex(Infinity, Infinity);
		public static const NAN:HComplex = new HComplex(NaN, NaN);
		public function HComplex(re:Number=0,im:Number=0){
			this.re = re;
			this.im = im;
		}
		
		/**
		 * 归一化
		 * @return
		 */
		public function sign():HComplex{
			var len:Number = abs;
			return new HComplex(re / len, im / len);
		}
		/**
		 * 模
		 */
		public function get abs():Number{
			return HMath.hypot(re, im);
		}
		
		/**
		 * 模的平方
		 */
		public function get abs2():Number{
			return re * re+im * im;
		}
		
		/**
		 * 加
		 * @param	c
		 * @return
		 */
		public function add(c:HComplex):HComplex{
			return new HComplex(re + c.re, im + c.im);
		}
		/**
		 * 减
		 * @param	c
		 * @return
		 */
		public function sub(c:HComplex):HComplex{
			return new HComplex(re - c.re, im - c.im);
		}
		
		/**
		 * 乘
		 * @param	c
		 * @return
		 */
		public function mul(c:HComplex):HComplex{
			return new HComplex(re * c.re - im * c.im, re * c.im + im * c.re);
		}
		
		/**
		 * 乘实数
		 * @param	n
		 * @return
		 */
		public function mul0(n:Number):HComplex{
			return new HComplex(re * n, im * n);
		}
		
		/**
		 * 除
		 * @param	c
		 * @return
		 */
		public function div(c:HComplex):HComplex{
			return this.mul(c.conjugate()).div0(c.abs2);
		}
		
		/**
		 * 除实数
		 * @param	n
		 * @return
		 */
		public function div0(n:Number):HComplex{
			var n1:Number = 1 / n;
			return new HComplex(re * n1, im * n1);
		}
		
		/**
		 * 共轭,z*
		 * @return
		 */
		public function conjugate():HComplex{
			return new HComplex(re, -im);
		}
		
		/**
		 * 倒数，1/z
		 * @return
		 */
		public function inverse():HComplex{
			var d:Number = abs2;
			return new HComplex(re / d, -im / d);
		}
		
		/**
		 * 求反，-z
		 * @return
		 */
		public function neg():HComplex{
			return new HComplex( -re, -im);
		}
		
		public function ceil(places:Number):HComplex{
			places = Math.pow(10, places || 0);

			return new HComplex(
				Math.ceil(re * places) / places,
				Math.ceil(im * places) / places);
		}
		
		public function floor(places:Number):HComplex{
			places = Math.pow(10, places || 0);

			return new HComplex(
				Math.floor(re * places) / places,
				Math.floor(im * places) / places);
		}
		
		public function round(places:Number):HComplex{
			places = Math.pow(10, places || 0);

			return new HComplex(
				Math.round(re * places) / places,
				Math.round(im * places) / places);
		}
		
		public function equals(c:HComplex):Boolean{
			return Math.abs(re-c.re) <= EPSILON &&  Math.abs(im - c.im) <= EPSILON;
		}
		
		public function clone():HComplex{
			return new HComplex(re, im);
		}
		
		public function toString():String{
			return "{re: " + re+", im: " + im + "}";
		}
		
		/**
		 * 复指数幂
		 * @param	c
		 * @return
		 */
		public function pow(z:HComplex):HComplex{
			/* I couldn't find a good formula, so here is a derivation and optimization
       *
       * z_1^z_2 = (a + bi)^(c + di)
       *         = exp((c + di) * log(a + bi)
       *         = pow(a^2 + b^2, (c + di) / 2) * exp(i(c + di)atan2(b, a))
       * =>...
       * Re = (pow(a^2 + b^2, c / 2) * exp(-d * atan2(b, a))) * cos(d * log(a^2 + b^2) / 2 + c * atan2(b, a))
       * Im = (pow(a^2 + b^2, c / 2) * exp(-d * atan2(b, a))) * sin(d * log(a^2 + b^2) / 2 + c * atan2(b, a))
       *
       * =>...
       * Re = exp(c * log(sqrt(a^2 + b^2)) - d * atan2(b, a)) * cos(d * log(sqrt(a^2 + b^2)) + c * atan2(b, a))
       * Im = exp(c * log(sqrt(a^2 + b^2)) - d * atan2(b, a)) * sin(d * log(sqrt(a^2 + b^2)) + c * atan2(b, a))
       *
       * =>
       * Re = exp(c * logsq2 - d * arg(z_1)) * cos(d * logsq2 + c * arg(z_1))
       * Im = exp(c * logsq2 - d * arg(z_1)) * sin(d * logsq2 + c * arg(z_1))
       *
       */
			var a:Number = re;
			var b:Number = im;
			var c:Number = z.re;
			var d:Number = z.im;
			var arg:Number = Math.atan2(b, a);
			var loh:Number = HMath.logHypot(a, b);
			a = Math.exp(c * loh - d * arg);
			b = d * loh + c * arg;
			return new HComplex(a*Math.cos(b),a*Math.sin(b));
		}
		
		/**
		 * 实指数幂
		 * @param	n
		 * @return
		 */
		public function pow0(n:Number):HComplex{
			var len:Number = abs;
			var theta:Number = Math.atan2(im, re);
			theta *= n;
			return new HComplex(len * Math.cos(theta), len * Math.sin(theta));
		}
		
		/**
		 * 开方
		 * @return
		 */
		public function sqrt():HComplex{
			var a:Number = re;
			var b:Number = im;
			var r:Number = abs;
			var _re:Number, _im:Number;
			if (a >= 0) {
				if (b === 0) {
					return new HComplex(Math.sqrt(a), 0);
				}
				_re = 0.5 * Math.sqrt(2.0 * (r + a));
			} else {
				_re = Math.abs(b) / Math.sqrt(2 * (r - a));
			}

			if (a <= 0) {
				_im = 0.5 * Math.sqrt(2.0 * (r - a));
			} else {
				_im = Math.abs(b) / Math.sqrt(2 * (r + a));
			}

			return new HComplex(_re, b < 0 ? -_im : _im);
		}
		
		public function exp():HComplex{
			var tmp:Number = Math.exp(re);

			if (im === 0) {
				return new HComplex(tmp, 0);
			}
			return new HComplex(
			      tmp * Math.cos(im),
			      tmp * Math.sin(im));
		}
		
		public function expm1():HComplex{
			/**
			* exp(a + i*b) - 1
			= exp(a) * (cos(b) + j*sin(b)) - 1
			= expm1(a)*cos(b) + cosm1(b) + j*exp(a)*sin(b)
			*/

			var a:Number = re;
			var b:Number = im;

			return new HComplex(
			      HMath.expm1(a) * Math.cos(b) + HMath.cosm1(b),
			      Math.exp(a) * Math.sin(b));
		}
		
		/**
		 * 自然对数
		 * @return
		 */
		public function log():HComplex{
			var a:Number = re;
			var b:Number = im;

			if (b === 0 && a > 0) {
				return new HComplex(Math.log(a), 0);
			}

			return new HComplex(
			      HMath.logHypot(a, b),
			      Math.atan2(b, a));
		}
		
		/**
		 * 幅角
		 * @return
		 */
		public function arg():Number{
			return Math.atan2(im, re);
		}
		
		/**
		 * 正弦
		 * @return
		 */
		public function sin():HComplex{
			// sin(c) = (e^b - e^(-b)) / (2i)
			var a:Number = re;
			var b:Number = im;
			return new HComplex(
				Math.sin(a) * HMath.cosh(b),
				Math.cos(a) * HMath.sinh(b));
		}
		
		/**
		 * 余弦
		 * @return
		 */
		public function cos():HComplex{
			// cos(z) = (e^b + e^(-b)) / 2
			var a:Number = re;
			var b:Number = im;
			return new HComplex(
				Math.cos(a) * HMath.cosh(b),
				-Math.sin(a) * HMath.sinh(b));
		}
		
		/**
		 * 正切
		 * @return
		 */
		public function tan():HComplex{
			// tan(c) = (e^(ci) - e^(-ci)) / (i(e^(ci) + e^(-ci)))
			var a:Number = 2 * re;
			var b:Number = 2 * im;
			var d:Number = Math.cos(a) + HMath.cosh(b);
			return new HComplex(
				Math.sin(a) / d,
				HMath.sinh(b) / d);
		}
		
		/**
		 * 余切
		 * @return
		 */
		public function cot():HComplex{
			// cot(c) = i(e^(ci) + e^(-ci)) / (e^(ci) - e^(-ci))

			var a:Number = 2 * re;
			var b:Number = 2 * im;
			var d = Math.cos(a) - HMath.cosh(b);

			return new HComplex(
				-Math.sin(a) / d,
				HMath.sinh(b) / d);
		}
		
		public function sec():HComplex{
			// sec(c) = 2 / (e^(ci) + e^(-ci))

			var a:Number = re;
			var b:Number = im;
			var d:Number = 0.5 * HMath.cosh(2 * b) + 0.5 * Math.cos(2 * a);

			return new HComplex(
				Math.cos(a) * HMath.cosh(b) / d,
				Math.sin(a) * HMath.sinh(b) / d);
		}
		
		public function csc():HComplex{
			// csc(c) = 2i / (e^(ci) - e^(-ci))

			var a:Number = re;
			var b:Number = im;
			var d:Number = 0.5 * HMath.cosh(2 * b) - 0.5 * Math.cos(2 * a);

			return new HComplex(
				Math.sin(a) * HMath.cosh(b) / d,
				-Math.cos(a) * HMath.sinh(b) / d);
		}
		
		public function asin():HComplex{
			// asin(c) = -i * log(ci + sqrt(1 - c^2))

			var a:Number = re;
			var b:Number = im;

			var t1:HComplex = new HComplex(
				b * b - a * a + 1,
				-2 * a * b).sqrt();

			var t2:HComplex = new HComplex(
				t1.re - b,
				t1.im + a).log();

			return new HComplex(t2.im, -t2.re);
		}
		
		public function acos():HComplex{
			// acos(c) = i * log(c - i * sqrt(1 - c^2))

			var a:Number = re;
			var b:Number = im;

			var t1:HComplex = new HComplex(
				b * b - a * a + 1,
				-2 * a * b).sqrt();

			var t2:HComplex = new HComplex(
				t1.re - b,
				t1.im + a).log();

			return new HComplex(Math.PI / 2 - t2.im, t2.re);
		}
		
		public function atan():HComplex{
			// atan(c) = i / 2 log((i + x) / (i - x))

			var a:Number = re;
			var b:Number = im;

			if (a === 0) {
				if (b === 1) {
				  return new HComplex(0, Infinity);
				}
				if (b === -1) {
				  return new HComplex(0, -Infinity);
				}
			}

			var d:Number = a * a + (1.0 - b) * (1.0 - b);

			var t1:HComplex = new HComplex(
				(1 - b * b - a * a) / d,
				-2 * a / d).log();

			return new HComplex(-0.5 * t1.im, 0.5 * t1.re);
		}
		
		public function acot():HComplex{
			// acot(c) = i / 2 log((c - i) / (c + i))

			var a:Number = re;
			var b:Number = im;

			if (b === 0) {
				return new HComplex(Math.atan2(1, a), 0);
			}

			var d:Number = a * a + b * b;
			return (d !== 0)
			      ? new HComplex(
			              a / d,
			              -b / d).atan()
			      : new HComplex(
			              (a !== 0) ? a / 0 : 0,
			              (b !== 0) ? -b / 0 : 0).atan();
		}
		
		public function asec():HComplex{
			// asec(c) = -i * log(1 / c + sqrt(1 - i / c^2))

			var a:Number = re;
			var b:Number = im;

			if (a === 0 && b === 0) {
				return new HComplex(0, Infinity);
			}

			var d:Number = a * a + b * b;
			return (d !== 0)
			      ? new HComplex(
			              a / d,
			              -b / d).acos()
			      : new HComplex(
			              (a !== 0) ? a / 0 : 0,
			              (b !== 0) ? -b / 0 : 0).acos();
		}
		
		public function acsc():HComplex{
			// acsc(c) = -i * log(i / c + sqrt(1 - 1 / c^2))

			var a:Number = re;
			var b:Number = im;

			if (a === 0 && b === 0) {
				return new HComplex(Math.PI / 2, Infinity);
			}

			var d:Number = a * a + b * b;
			return (d !== 0)
			      ? new HComplex(
			              a / d,
			              -b / d).asin()
			      : new HComplex(
			              (a !== 0) ? a / 0 : 0,
			              (b !== 0) ? -b / 0 : 0).asin();
		}
		
		public function sinh():HComplex{
			// sinh(c) = (e^c - e^-c) / 2

			var a:Number = re;
			var b:Number = im;

			return new HComplex(
			      HMath.sinh(a) * Math.cos(b),
			      HMath.cosh(a) * Math.sin(b));
		}
		
		public function cosh():HComplex{
			// cosh(c) = (e^c + e^-c) / 2

			var a:Number = re;
			var b:Number = im;

			return new HComplex(
			      HMath.cosh(a) * Math.cos(b),
			      HMath.sinh(a) * Math.sin(b));
		}
		
		public function tanh():HComplex{
			// tanh(c) = (e^c - e^-c) / (e^c + e^-c)

			var a:Number = re;
			var b:Number = im;
			var d:Number = HMath.cosh(a) + Math.cos(b);

			return new HComplex(
			      HMath.sinh(a) / d,
			      Math.sin(b) / d);
		}
		
		public function coth():HComplex{
			// coth(c) = (e^c + e^-c) / (e^c - e^-c)

			var a:Number = re;
			var b:Number = im;
			var d:Number = HMath.cosh(a) - Math.cos(b);

			return new HComplex(
			      HMath.sinh(a) / d,
			      -Math.sin(b) / d);
		}
		
		public function csch():HComplex{
			// csch(c) = 2 / (e^c - e^-c)

			var a:Number = re;
			var b:Number = im;
			var d:Number = Math.cos(2 * b) - HMath.cosh(2 * a);

			return new HComplex(
			      -2 * HMath.sinh(a) * Math.cos(b) / d,
			      2 * HMath.cosh(a) * Math.sin(b) / d);
		}
		
		public function sech():HComplex{
			// sech(c) = 2 / (e^c + e^-c)

			var a:Number = re;
			var b:Number = im;
			var d:Number = Math.cos(2 * b) + HMath.cosh(2 * a);

			return new HComplex(
			      2 * HMath.cosh(a) * Math.cos(b) / d,
			      -2 * HMath.sinh(a) * Math.sin(b) / d);
		}
		
		public function asinh():HComplex{
			// asinh(c) = log(c + sqrt(c^2 + 1))

			var tmp:Number = im;
			im = -re;
			re = tmp;
			var res:HComplex = asin();

			re = -im;
			im = tmp;
			tmp = res.re;

			res.re = -res.im;
			res.im = tmp;
			return res;
		}
		
		public function acosh():HComplex{
			// acosh(c) = log(c + sqrt(c^2 - 1))

			var res:HComplex = acos();
			var tmp:Number;
			if (res.im <= 0) {
				tmp = res.re;
				res.re = -res.im;
				res.im = tmp;
			} else {
				tmp = res.im;
				res.im = -res.re;
				res.re = tmp;
			}
			return res;
		}
		
		public function atanh():HComplex{
			// atanh(c) = log((1+c) / (1-c)) / 2

			var a:Number = re;
			var b:Number = im;

			var noIM:Boolean = a > 1 && b === 0;
			var oneMinus:Number = 1 - a;
			var onePlus:Number = 1 + a;
			var d:Number = oneMinus * oneMinus + b * b;

			var x = (d !== 0)
			      ? new HComplex(
			              (onePlus * oneMinus - b * b) / d,
			              (b * oneMinus + onePlus * b) / d)
			      : new HComplex(
			              (a !== -1) ? (a / 0) : 0,
			              (b !== 0) ? (b / 0) : 0);

			var temp:Number = x.re;
			x.re = HMath.logHypot(x.re, x.im) / 2;
			x.im = Math.atan2(x.im, temp) / 2;
			if (noIM) {
				x.im = -x.im;
			}
			return x;
		}
		
		public function acoth():HComplex{
			// acoth(c) = log((c+1) / (c-1)) / 2

			var a:Number = re;
			var b:Number = im;

			if (a === 0 && b === 0) {
				return new HComplex(0, Math.PI / 2);
			}

			var d:Number = a * a + b * b;
			return (d !== 0)
			      ? new HComplex(
			              a / d,
			              -b / d).atanh()
			      : new HComplex(
			              (a !== 0) ? a / 0 : 0,
			              (b !== 0) ? -b / 0 : 0).atanh();
		}
		
		public function acsch():HComplex{
			// acsch(c) = log((1+sqrt(1+c^2))/c)

			var a:Number = re;
			var b:Number = im;

			if (b === 0) {

			return new HComplex(
			        (a !== 0)
			        ? Math.log(a + Math.sqrt(a * a + 1))
			        : Infinity, 0);
			}

			var d:Number = a * a + b * b;
			return (d !== 0)
			      ? new HComplex(
			              a / d,
			              -b / d).asinh()
			      : new HComplex(
			              (a !== 0) ? a / 0 : 0,
			              (b !== 0) ? -b / 0 : 0).asinh();
		}
		
		public function asech():HComplex{
			// asech(c) = log((1+sqrt(1-c^2))/c)

			var a:Number = re;
			var b:Number = im;

			if (this.isZero()) {
				return INFINITY.clone();
			}

			var d:Number = a * a + b * b;
			return (d !== 0)
			      ? new HComplex(
			              a / d,
			              -b / d).acosh()
			      : new HComplex(
			              (a !== 0) ? a / 0 : 0,
			              (b !== 0) ? -b / 0 : 0).acosh();
		}
		
		public function isZero():Boolean{
			return re === 0 && im === 0;
		}
		
	}
}