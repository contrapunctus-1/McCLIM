;;; -*- Mode: Lisp; Package: CLIM-INTERNALS -*-

;;;  (c) copyright 1998,1999,2000 by Michael McDonald (mikemac@mikemac.com)

;;; This library is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU Library General Public
;;; License as published by the Free Software Foundation; either
;;; version 2 of the License, or (at your option) any later version.
;;;
;;; This library is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; Library General Public License for more details.
;;;
;;; You should have received a copy of the GNU Library General Public
;;; License along with this library; if not, write to the 
;;; Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
;;; Boston, MA  02111-1307  USA.

(in-package :CLIM-INTERNALS)

(defclass graft (sheet-multiple-child-mixin mirrored-sheet-mixin sheet)
  ((orientation :initform :default
		:initarg :orientation
		:reader graft-orientation)
   (units :initform :device
	  :initarg :units
	  :reader graft-units)
   (mirror :initarg :mirror)
   )
  )

(defmethod initialize-instance :after ((graft graft) &rest args)
  (declare (ignore args))
  (port-register-mirror (port graft) graft (slot-value graft 'mirror)))
;  (setf (graft graft) graft))

(defun graftp (x)
  (typep x 'graft))

(defmethod graft ((graft graft))
  graft)

(defmethod sheet-grafted-p ((sheet sheet))
  (if (sheet-parent sheet)
      (sheet-grafted-p (sheet-parent sheet))))

(defmethod sheet-grafted-p ((graft graft))
  t)

(defun find-graft (&key (port nil)
			(server-path *default-server-path*)
			(orientation :default)
			(units :device))
  (if (null port)
      (setq port (find-port :server-path server-path)))
  (block find-graft
    (map-over-grafts #'(lambda (graft)
			 (if (and (eq orientation (graft-orientation graft))
				  (eq units (graft-units graft)))
			     (return-from find-graft graft)))
		     port)
    (return-from find-graft (make-graft port :orientation orientation :units units))))

(defun map-over-grafts (function port)
  (mapc function (port-grafts port)))

(defmacro with-graft-locked (graft &body body)
  `(let ((graft ,graft))
     ,@body))

(defmethod graft-width ((graft graft) &key (units :device))
  (if (eq units :device)
      1000
    1))

(defmethod graft-height ((graft graft) &key (units :device))
  (if (eq units :device)
      1000
    1))

(defmethod graft-pixels-per-millimeter ((graft graft))
  2.8346s0)

(defmethod graft-pixels-per-inch ((graft graft))
  72.0)
