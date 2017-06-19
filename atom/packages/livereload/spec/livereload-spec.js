"use babel";

describe('LiveReload for Atom', () => {
  var workspaceElement, statusBar, livereload;

  beforeEach( () => {
    workspaceElement = atom.views.getView(atom.workspace);

    return waitsForPromise( () => atom.packages.activatePackage('livereload') );
  });

  describe('@activate', () => {
    it('should be activated', () => {
      expect(atom.packages.isPackageLoaded('livereload')).toBe(true);
      expect(atom.packages.isPackageActive('livereload')).toBe(true);
    });
  });

  describe('@deactivate', () => {
    it('should be deactivated', () => {
      atom.packages.deactivatePackage('livereload');
      expect(atom.packages.isPackageActive('livereload')).toBe(false);
    });
  });
});
